require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    @setting = settings(:setting_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    #assert_equal @setting.slogan, assigns(:setting).slogan
    #assert_equal @setting.app_version, assigns(:setting).app_version
    assert_equal @setting, assigns(:setting)
  end

end
