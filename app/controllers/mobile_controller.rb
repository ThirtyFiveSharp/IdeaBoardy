class MobileController < ApplicationController
  layout "mobile"

  def index
    @setting = Setting.first
  end
end
