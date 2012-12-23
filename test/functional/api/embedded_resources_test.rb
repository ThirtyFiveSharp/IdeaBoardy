require 'test_helper'

class Api::EmbeddedResourcesTest < ActionController::TestCase
  tests Api::BoardsController

  setup do
    @board = boards(:board_one)
  end

  test "should only include embedded resources specified by request parameters" do
    get :show, id: @board.id, embed: "sections, tags"
    assert_response :success
    actual_board = ActiveSupport::JSON.decode @response.body
    assert_equal @board.id, actual_board['id']
    assert_equal @board.sections.count, actual_board['sections'].count
    assert_equal @board.tags.count, actual_board['tags'].count
    assert_nil actual_board['concepts']
  end

  test "should not include embedded resources if not specified" do
    get :show, id: @board.id
    assert_response :success
    actual_board = ActiveSupport::JSON.decode @response.body
    assert_equal @board.id, actual_board['id']
    assert_nil actual_board['sections']
    assert_nil actual_board['concepts']
    assert_nil actual_board['tags']
  end

end
