class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  respond_to 'html'

  def show
    @setting = Setting.first
  end

  def edit
    @setting = Setting.first
  end

  def update
    @setting = Setting.first
    if @setting.update_attributes(params[:setting])
      redirect_to admin_settings_path
    else
      render action: "edit"
    end
  end
end
