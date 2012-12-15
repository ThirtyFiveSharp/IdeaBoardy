class AddDefaultSetting < ActiveRecord::Migration
  def up
    Setting.table_name = "admin_settings"
    Setting.create! do |s|
      s.slogan = "Let's move!"
      s.app_version = "0.0.2-Alpha"
    end
    puts "Default setting initialized!"
  end

  def down
    Setting.table_name = "admin_settings"
    Setting.delete_all
    puts "Setting is cleared!"
  end
end
