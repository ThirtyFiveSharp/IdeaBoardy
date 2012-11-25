class HomeController < ApplicationController
  def index
    @slogan = "Let's move!"
    @version = "0.0.1-alpha"
  end
end
