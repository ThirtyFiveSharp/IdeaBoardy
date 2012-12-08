class AddColorToSections < ActiveRecord::Migration
  def change
    add_column :sections, :color, :string
    Board.all.each do |board|
      index = 0
      board.sections.each do |section|
        section.update_attributes! :color => Section::COLORS[index % 6]
        index += 1
      end
    end
  end
end
