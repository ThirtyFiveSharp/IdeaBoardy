class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :board_id
      t.timestamps
    end

    create_table :ideas_tags do |t|
      t.integer :tag_id
      t.integer :idea_id
    end
  end
end
