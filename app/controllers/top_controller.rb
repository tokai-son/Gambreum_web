class TopController < ApplicationController
  # before_action :check_login, {only: [:main]}

  def main
  end

  def login
    respond_to do |format|
      format.js
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

end
