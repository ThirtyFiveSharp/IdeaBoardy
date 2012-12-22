require 'test_helper'

class Api::BoardTagsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @board = boards(:board_one)
    @tag1 = tags(:tag_one)
    @tag2 = tags(:tag_two)
  end

  test "should get tags for the given board" do
    expected_tags = [@tag2, @tag1]
    get :index, board_id: @board.id
    assert_response :success
    actual_tags = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_tags.count, "should return all two tags"
    expected_tags.each_with_index do |expected_tag, index|
      assert_equal expected_tag.id, actual_tags[index]['id']
      assert_equal expected_tag.name, actual_tags[index]['name']
      links = actual_tags[index]['links']
      assert_equal 1, links.count
      section_link = links.select { |l| l['rel'] == 'tag' }.first
      assert_equal api_tag_url(expected_tag.id), section_link['href']
    end
  end

  test "should return 404 Not Found when given board is not existed (INDEX)" do
    get :index, board_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create tag for given board" do
    expected_name = "New tag name"
    assert_difference("Tag.of_board(#{@board.id}).count") do
      post :create, board_id: @board.id, board_tag: {name: expected_name}
    end
    created_tag_id = assigns :tag_id
    assert_response :created
    assert_equal api_tag_url(created_tag_id), @response.headers['Location']

    actual_tag = Tag.find created_tag_id
    assert_equal expected_name, actual_tag.name
    assert_equal @board.id, actual_tag.board.id

    returned_tag = ActiveSupport::JSON.decode @response.body
    assert_equal actual_tag.id, returned_tag['id']
    assert_equal actual_tag.name, returned_tag['name']
    links = returned_tag['links']
    assert_equal 1, links.count
    self_link = links.select {|l| l['rel'] == 'self'}.first
    assert_equal api_tag_url(created_tag_id), self_link['href']
  end

  test "should return unprocessable_entity status when create a tag without name" do
    post :create, board_id: @board.id, board_tag: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when given board is not existed (POST)" do
    post :create, board_id: NON_EXISTED_ID, board_tag: {name: "New tag name"}
    assert_response :not_found
    assert_blank @response.body
  end
end
