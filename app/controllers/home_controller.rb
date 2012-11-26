class HomeController < ApplicationController
  def index
    @slogan = "Let's move!"
    @version = "0.0.2-alpha"
  end
end
