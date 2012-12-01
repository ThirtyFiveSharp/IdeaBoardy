class AddDefaultSetting < ActiveRecord::Migration
  def up
    Admin::Setting.create! do |s|
      s.slogan = "Let's move!"
      s.app_version = "0.0.2-Alpha"
    end
    puts "Default setting initialized!"
  end

  def down
    Admin::Setting.delete_all
    puts "Setting is cleared!"
  end
end
