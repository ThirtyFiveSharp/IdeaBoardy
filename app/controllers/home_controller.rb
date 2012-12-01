class HomeController < ApplicationController
  def index
    @setting = Admin::Setting.first
  end
end
