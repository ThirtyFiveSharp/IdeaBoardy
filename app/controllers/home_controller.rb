class HomeController < ApplicationController
  def index
    #@setting = Admin::Setting.first
    @setting = Admin::Setting.new(slogan: "Let's move!", app_version: "0.0.2-Alpha")
  end
end
