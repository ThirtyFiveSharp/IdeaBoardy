class AddBoardIdToConcepts < ActiveRecord::Migration
  def change
    add_column :concepts, :board_id, :integer
  end
end
