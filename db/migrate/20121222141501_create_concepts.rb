class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name
      t.integer :lock_version, default: 1
      t.timestamps
    end
    add_column :tags, :concept_id, :integer
  end
end
