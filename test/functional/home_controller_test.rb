require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    @setting = admin_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal @setting.slogan, assigns(:setting).slogan
    assert_equal @setting.app_version, assigns(:setting).app_version
  end

end
