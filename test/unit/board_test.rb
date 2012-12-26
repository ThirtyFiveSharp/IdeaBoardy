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

  test "board should have name" do
    assert_raise "Board should have name.", ActiveRecord::RecordInvalid do
      Board.create!
    end
  end

  test "should raise ActiveRecord::StaleObjectError when update already modified board" do
    Board.create!(name: "board_for_optimistic_lock")
    board1 = Board.find_by_name("board_for_optimistic_lock")
    board2 = Board.find_by_name("board_for_optimistic_lock")
    board1.name = "board1"
    board1.save!
    assert_raise "not allowed to update already modified idea", ActiveRecord::StaleObjectError do
      board2.name = "board2"
      board2.save!
    end
  end

  test "Board.all_exists?() should return false if not all boards exists" do
    board = Board.create!(name: "name1")
    assert_equal false, Board.all_exists?([board.id, -1])
  end

  test "Board.all_exists?() should return true if all boards exists" do
    board1 = Board.create!(name: "name1")
    board2 = Board.create!(name: "name2")
    assert_equal true, Board.all_exists?([board1.id, board2.id])
  end
end
