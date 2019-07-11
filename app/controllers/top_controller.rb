class TopController < ApplicationController
  # before_action :check_login, {only: [:main]}

  def main
  end

  def login
    logger.debug("From: top_controller.rb: login controller executed !")
  end

  def warning_page
  end

  def check_login
    if session[:logined] == nil
      flash[:notice] = "Please Login Via Metamask !!"
      redirect_to("/")
    end
  end

end
