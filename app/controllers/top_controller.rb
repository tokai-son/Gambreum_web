class TopController < ApplicationController
  # before_action :check_login, {only: [:main]}
  require "json"
  before_action :readyForAbi

  def readyForAbi
    @json_data = File.open("app/assets/javascripts/contract_abi/GambreumPlayer.json", "rt:utf-8:utf-8") do |j|
      JSON.load(j)
    end
    @json_data = JSON.generate(@json_data["abi"]) #そのまま渡すと=>がアウトなのでgenerateで:に変える
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
    if(@givenTip.to_i <= 0)
      flash[:notice] = "1GTIPもかけんとは舐めとんのか!! ページを更新せいー。"
    else
      flash[:notice] = "決着！"
    end
  end

end
