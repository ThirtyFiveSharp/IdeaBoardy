class RenameAdminSetting < ActiveRecord::Migration
  def up
    rename_table :admin_settings, :settings
  end

  def down
    rename_table :settings, :admin_settings
  end
end
