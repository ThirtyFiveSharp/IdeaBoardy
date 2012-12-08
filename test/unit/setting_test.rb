require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:setting_one)
  end

  test "should get default setting" do
    setting = Setting.first
    assert_not_nil(setting)
    assert_equal @setting.slogan, setting.slogan
    assert_equal @setting.app_version, setting.app_version
  end

  test "should not allow to create more than one settings" do
    assert_raise "not allow to create more than one settings", ActiveRecord::ActiveRecordError do
      Setting.create!(slogan: "slogan", app_version: "1.0.0")
    end
  end

end
