class AddLockVersionToSection < ActiveRecord::Migration
  def change
    add_column :sections, :lock_version, :integer, default: 1
  end
end
