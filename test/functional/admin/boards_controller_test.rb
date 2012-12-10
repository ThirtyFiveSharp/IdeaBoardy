require 'test_helper'

class Admin::BoardsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_one)
    @board = boards(:board_one)
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

  test "should export boards to yaml data" do
    get :export, boards: [@board.id]

    yaml = YAML.load(@response.body)
    assert_equal 1, yaml.count
    actual_board = yaml[0]
    assert_equal @board.name, actual_board["name"]
    assert_equal @board.description, actual_board["description"]
    actual_sections = actual_board["sections"]
    assert_equal @board.sections.count, actual_sections.count
    @board.sections.each_with_index do |section, index|
      assert_equal section.name, actual_sections[index]["name"]
      assert_equal section.color, actual_sections[index]["color"]
      actual_ideas = actual_sections[index]["ideas"]
      assert_equal section.ideas.count, actual_ideas.count
      section.ideas.each_with_index do |idea, index|
        assert_equal idea.content, actual_ideas[index]["content"]
        assert_equal idea.vote, actual_ideas[index]["vote"]
      end
    end
  end

  test "should alert 'board(s) not found' and redirect to index when board not found" do
    get :export, boards: [-1]
    assert_equal "board(s) not found", flash[:alert]
    assert_redirected_to :action => "index"
  end
end
