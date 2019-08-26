class TopController < ApplicationController
  require 'uri'
  require "json"
  require "ethereum"
  require 'net/http'
  before_action :readyForAbi
  ETHEREUM_TOKEN_PATH = "#{Dir.pwd}/contracts/GambreumPlayer.sol"
  ROPSTEN_URL = "https://ropsten.infura.io/v3/71f5b3790e834e0d93a94eff86aef58e"
  CONTRACT_ADDRESS = "0x0B19Fd715171484E658e61a61b2891772d89b099"
  DEFAULT_GAS_LIMIT = 4_000_000
  DEFAULT_GAS_PRICE = 22_000_000_000

  def readyForAbi
    @json_data = File.open("app/assets/javascripts/contract_abi/GambreumPlayer.json", "rt:utf-8:utf-8") do |j|
      JSON.load(j)
    end
    @json_data = JSON.generate(@json_data["abi"]) #そのまま渡すと=>がアウトなのでgenerateで:に変える
    @bin_data  = @json_data["bytecode"]
  end

  def main
    # 重い処理なのでsessionをみて、最初だけ発動するようにする（あとで)
    # ここでFileOpenして、叩く
  end

  def login
    logger.debug("From: top_controller.rb: login controller executed !")
  end

  def register
    @username = params[:username]
    if @username === ""
      flash[:notice] = "input username!!"
    end
  end

  def warning_page
  end


  def check_login
    if session[:logined] == nil
      flash[:notice] = "Please Login Via Metamask !!"
      redirect_to("/")
    end
  end

  def duel
    @givenTip = params[:givenTip]
    @userTip = params[:user_gtip]
    @user_wallet = params[:user_wallet]

    @player_dices = [
      params[:dice1Val],
      params[:dice2Val],
      params[:dice3Val]
    ]

    @dealer_dices = [
      params[:dice4Val],
      params[:dice5Val],
      params[:dice6Val]
    ]

    if(@givenTip.to_i > @userTip.to_i)
      flash[:notice] = "掛け金が足りない！"
      @reward = -1
    elsif(@givenTip.to_i == 0)
      flash[:notice] = "掛け金無しで勝負じゃと・・・けーれ！"
      @reward = -1
    else
      player_strength = decisionValuer(@player_dices)
      dealer_strength = decisionValuer(@dealer_dices)
      if(player_strength > dealer_strength)
        @reward = @givenTip.to_i * decisionReward(player_strength, dealer_strength)
        flash[:notice] = "あなたの勝ち!(+" + @reward.to_s(10) + " GTIP)"
        @transaction_hash = exeRewardProc(@reward, @user_wallet, true)
      elsif(dealer_strength > player_strength)
        @reward = @givenTip.to_i * decisionReward(dealer_strength, player_strength)
        flash[:notice] = "下手だなぁ...下手っぴさ(-U-) (-" + @reward.to_s(10) + " GTIP)"
        @transaction_hash = exeRewardProc(@reward, @user_wallet, false) # FIX: ここを減らす関数に書き換える！
      else
        flash[:notice] = "引き分け...GTIPは動かない"
        @reward = -2
      end
    end
    logger.debug(@reward)
  end

  ## Utility Methods ##
  def decisionValuer(dices)
    # 111 Pinzoro
    if(
      dices[0] == "1" &&
      dices[1] == "1" &&
      dices[2] == "1"
    )
      return 13
    end

    # Zorome excepted for Pinzoro
    if(
      dices[0] == dices[1] &&
      dices[0] == dices[2] &&
      dices[1] == dices[2] &&
      dices[0] != "1"
    )
      logger.debug("zorome")
      return dices[0].to_i + 5
    end

    # Nomal Deme
    if(dices[0] == dices[1])
      return dices[2].to_i
    elsif (dices[0] == dices[2])
      return dices[1].to_i
    elsif (dices[1] == dices[2])
      return dices[0].to_i
    end

    # 456 Shigoro
    if(
      dices.include?("4") &&
      dices.include?("5") &&
      dices.include?("6")
    )
      return 12
    end

    # 123 Hihumi
    if(
      dices.include?("1") &&
      dices.include?("2") &&
      dices.include?("3")
    )
      return -1
    end

    # Menasi
    return 0
  end

  def decisionReward(winner_strength, loser_strength)
    return 2 if loser_strength == -1 || (winner_strength > 6 && winner_strength < 12) # 2倍付
    return 1 if winner_strength > 0 && winner_strength < 7 # 1倍
    return 3 if winner_strength == 12 # ゾロ目 3倍付
    return 5 if winner_strength == 13 # ピンゾロォ！ ５倍付
  end

  def exeRewardProc(amount, user_wallet, is_earn)
    # Create instanse from my private key whose is Gambrerum Owner.
    key = Eth::Key.new priv: "B99BCC73D95361125C0AC570F7AFD6A432D75999FF96295B0A8CC253C9C30392"

    # Get transaction count
    response = getMyTransactionCount()
    string_response = response.body
    json_response = JSON.parse(string_response)
    my_nonce = json_response["result"]

    # Create hex_data as a payload on this tx.
    if(is_earn == true)
      selector = Digest::SHA3.hexdigest("publishTokenToPlayer(uint256,address)", 256).slice(0..7) # 最初の4Byteを使う
    else
      selector = Digest::SHA3.hexdigest("returnToken(uint256,address)", 256).slice(0..7) # 最初の4Byteを使う
    end
    amount = amount.to_s(16) # 0xへ
    arg1_uint = amount.rjust(64, "0") #FIX: 10進数だから16に直す！
    arg2_address = user_wallet.slice(2..-1)
    arg2_address = arg2_address.rjust(64, "0")
    hex_data = "0x" + selector + arg1_uint + arg2_address

    tx = Eth::Tx.new({
      data: hex_data,
      gas_limit: DEFAULT_GAS_LIMIT,
      gas_price: DEFAULT_GAS_PRICE,
      nonce: my_nonce.hex,
      from: "0x6CaFf8d3958dB8EF53b1Abbe10622c26DBFa4778",
      to: CONTRACT_ADDRESS,
      value: 0
    })

    # Sign this transaction by the key
    tx.sign key

    transaction_response = sendMyRawTransaction(tx.hex)
    transaction_response_string = transaction_response.body
    logger.debug(transaction_response_string)
    transaction_response_json = JSON.parse(transaction_response_string)
    return transaction_response_json["result"]
  end

  def getMyTransactionCount
    uri = URI.parse(ROPSTEN_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "jsonrpc" => "2.0",
      "method" => "eth_getTransactionCount",
      "params" => [
        "0x6CaFf8d3958dB8EF53b1Abbe10622c26DBFa4778",
        "latest"
      ],
      "id" => 1
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    return response
  end

  def sendMyRawTransaction(signed_pay_load)
    uri = URI.parse(ROPSTEN_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "jsonrpc" => "2.0",
      "method" => "eth_sendRawTransaction",
      "params" => [
        signed_pay_load
      ],
      "id" => 1
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    return response
  end

end
