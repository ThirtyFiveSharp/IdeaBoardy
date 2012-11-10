class AddLockVersionToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :lock_version, :integer, default: 1
  end
end
