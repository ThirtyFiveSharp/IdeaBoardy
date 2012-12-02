class HomeController < ApplicationController
  def index
    @setting = Setting.first
  end
end
