class AddLockVersionToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :lock_version, :integer, default: 1
  end
end
