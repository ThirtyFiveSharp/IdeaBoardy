class CreateAdminSettings < ActiveRecord::Migration
  def change
    create_table :admin_settings do |t|
      t.string :slogan
      t.string :app_version

      t.timestamps
    end
  end
end
