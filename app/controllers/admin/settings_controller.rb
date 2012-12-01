class Admin::SettingsController < ApplicationController
  layout 'admin'
  respond_to 'html'

  def show
    @setting = Admin::Setting.first
  end

  def edit
    @setting = Admin::Setting.first
  end

  def update
    @setting = Admin::Setting.first
    if @setting.update_attributes(params[:admin_setting])
      redirect_to admin_settings_path
    else
      render action: "edit"
    end
  end
end
