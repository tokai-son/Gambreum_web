class TopController < ApplicationController
  # before_action :check_login, {only: [:main]}

  def main
  end

  def login
  end

  def warning_page
  end

  def check_login
    if session[:logined] == nil
      flash[:notice] = "Please Login Via Metamask !!"
      redirect_to("/top/warning_page")
    end
  end

end
