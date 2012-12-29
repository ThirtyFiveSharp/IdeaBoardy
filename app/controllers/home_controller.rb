require 'net/http'

class HomeController < ApplicationController
  include ShortenUrl

  def index
    @setting = Setting.first
    path = request.path
    origin_url = get_origin_url(path, request.query_string)
    if !origin_url.nil?
      redirect_to origin_url
    end
  end
end
