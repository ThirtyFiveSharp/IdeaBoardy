require 'test_helper'

class Admin::BoardsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_one)
    sign_in @user
  end

  test "should get index" do
    expected_boards = Board.all
    get :index
    assert_response :success
    actual_boards = assigns(:boards)
    assert_equal expected_boards.count, actual_boards.count
    expected_boards.each_with_index do |board, index|
      assert_equal board.id, actual_boards[index][:id]
      assert_equal board.name, actual_boards[index][:name]
      assert_equal board.sections.count, actual_boards[index][:total_sections_count]
      assert_equal board.sections.sum {|section| section.ideas.count}, actual_boards[index][:total_ideas_count]
    end
  end

end
