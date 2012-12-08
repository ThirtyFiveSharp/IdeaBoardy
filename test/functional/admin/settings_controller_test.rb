require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase
  setup do
    @setting = settings(:setting_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should show admin_setting" do
    get :show
    assert_response :success
    assert_equal @setting, assigns(:setting)
  end

  test "should get edit" do
    get :edit
    assert_response :success
    assert_equal @setting, assigns(:setting)
  end

  test "should update admin_setting" do
    put :update, setting: { app_version: "new version", slogan: "new slogan" }
    assert_redirected_to admin_settings_path
    setting = Setting.first
    assert_equal "new slogan", setting.slogan
    assert_equal "new version", setting.app_version
  end
end
