require 'net/http'

class HomeController < ApplicationController
  include ShortenUrl

  def index
    #redirect_to m_path if mobile_device?
    @setting = Setting.first
  end

  #def mobile_device?
  #  if session[:mobile_param]
  #    session[:mobile_param] == "1"
  #  else
  #    request.user_agent =~ /Mobile|webOS/
  #  end
  #end
end