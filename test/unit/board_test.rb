require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  setup do
    Board.delete_all
  end

  test "should add a section" do
    board = Board.new name: "Board name"
    board.save

    section = Section.new name: "Section name"
    board.sections << section

    actual_board = Board.find board.id
    assert_equal 1, actual_board.sections.count
    assert_equal section.id, actual_board.sections.first.id
  end

  test "board name should be unique" do
    board_name = "Board name"
    Board.create name: board_name

    assert_raise "Board with duplicated name should not be created.", ActiveRecord::RecordInvalid do
      Board.create! name: board_name
    end
  end

end
