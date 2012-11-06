class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.text :content
      t.integer :vote
      t.integer :section_id
      t.timestamps
    end
  end
end
