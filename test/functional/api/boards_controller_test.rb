require 'test_helper'

class Api::BoardsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  include ShortenUrl

  setup do
    @board1 = boards(:board_one)
    @board2 = boards(:board_two)
  end

  test "should get index" do
    expected_boards = [@board1, @board2]
    get :index
    assert_response :success
    actual_boards = ActiveSupport::JSON.decode @response.body
    assert_equal expected_boards.count, actual_boards.count
    expected_boards.each_with_index do |expected_board, index|
      assert_equal expected_board.id, actual_boards[index]['id']
      assert_equal expected_board.name, actual_boards[index]['name']
      assert_equal get_shorten_url("api_board", expected_board.id), actual_boards[index]['shortenUrlCode']
      links = actual_boards[index]['links']
      assert_equal 1, links.count
      board_link = links.select { |l| l['rel'] == 'board' }.first
      assert_equal api_board_url(expected_board.id), board_link['href']
    end
  end

  test "should create board" do
    expected_name = "New board name"
    expected_description = "New board description"
    assert_difference('Board.count') do
      post :create, board: {name: expected_name, description: expected_description}
    end
    created_board_id = assigns :board_id
    assert_response :created
    assert_equal api_board_url(created_board_id), @response.headers['Location']
    assert_blank @response.body
    actual_board = Board.find created_board_id
    assert_equal expected_name, actual_board.name
    assert_equal expected_description, actual_board.description
  end

  test "should return unprocessable_entity status when create a board without name" do
    post :create, board: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should show board" do
    get :show, id: @board1.id
    assert_response :success
    actual_board = ActiveSupport::JSON.decode @response.body
    assert_equal @board1.id, actual_board['id']
    assert_equal @board1.name, actual_board['name']
    assert_equal @board1.description, actual_board['description']
    assert_equal get_shorten_url("api_board", @board1.id), actual_board['shortenUrlCode']
    links = actual_board['links']
    assert_equal 7, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal api_board_url(@board1.id), self_link['href']
    sections_link = links.select { |l| l['rel']=='sections' }.first
    assert_equal api_board_sections_url(@board1.id), sections_link['href']
    concepts_link = links.select { |l| l['rel']=='concepts' }.first
    assert_equal api_board_concepts_url(@board1.id), concepts_link['href']
    tags_link = links.select { |l| l['rel']=='tags' }.first
    assert_equal api_board_tags_url(@board1.id), tags_link['href']
    invitation_link = links.select { |l| l['rel']=='invitation' }.first
    assert_equal api_emails_invitation_url, invitation_link['href']
    share_link = links.select { |l| l['rel']=='share' }.first
    assert_equal api_emails_share_url, share_link['href']
    tag_cloud_link = links.select { |l| l['rel']=='tagcloud' }.first
    assert_equal api_board_tagcloud_index_url(@board1.id), tag_cloud_link['href']
  end

  test "should return 404 Not Found when board is not existed (GET)" do
    get :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update board" do
    expected_name = "New board name"
    expected_description = "New board description"
    put :update, id: @board1.id, board: {description: expected_description, name: expected_name}
    assert_response :no_content
    assert_blank @response.body
    actual_board = Board.find @board1.id
    assert_equal expected_name, actual_board.name
    assert_equal expected_description, actual_board.description
  end

  test "should return unprocessable_entity status when clear name of a board" do
    put :update, id: @board1.id, board: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when board is not existed (UPDATE)" do
    put :update, id: NON_EXISTED_ID, board: {description: "new board description", name: "new board name"}
    assert_response :not_found
    assert_blank @response.body
  end

  test "should destroy board together with associated sections, tag and ideas" do
    section_ids = @board1.sections.collect { |s| s.id }
    tag_ids = @board1.tags.collect { |t| t.id }
    idea_ids = @board1.sections.collect { |s| s.ideas }.flatten.collect { |i| i.id }
    assert_difference('Board.count', -1) do
      delete :destroy, id: @board1.id
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Board.exists?(@board1.id), "Board should be deleted."
    section_ids.each { |id| assert_equal false, Section.exists?(id), "Associated sections should be deleted." }
    tag_ids.each { |id| assert_equal false, Tag.exists?(id), "Associated tags should be deleted." }
    idea_ids.each { |id| assert_equal false, Idea.exists?(id), "Associated ideas should be deleted." }
  end

  test "should return 204 No Content when board is not existed" do
    delete :destroy, id: NON_EXISTED_ID
    assert_response :no_content
    assert_blank @response.body
  end

end
