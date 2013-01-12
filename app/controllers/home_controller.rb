require 'net/http'

class HomeController < ApplicationController
  include ShortenUrl

  def index
    @setting = Setting.first
  end
end