class BattleController < ApplicationController
  def result
    @winner = ""

    dealer, player = diceRoll()

    @winner = winnerDecision(dealer, player)

    if(@winner == "dealer")
    elsif(@winner == "player")
    else # Draw
    end
  end

  def diceRoll
    dealer = []
    player = []

    6.times do |num|
      if num%2 == 0
        dealer.push(rand(7))
      else
        player.push(rand(7))
      end
    end
    return dealer, player
  end

  def winnerDecision(delare, player)
  end

  def diceValueDicision(value)
  end

end
