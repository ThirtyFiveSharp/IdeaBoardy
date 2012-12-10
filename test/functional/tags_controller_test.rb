require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @board = boards(:board_one)
    @board2 = boards(:board_two)
    @tag1 = tags(:tag_one)
    @tag2 = tags(:tag_two)
  end

  test "should get index" do
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
      assert_equal board_tag_url(expected_tag.board.id, expected_tag.id), section_link['href']
    end
  end

  test "should return 404 Not Found when given board is not existed (INDEX)" do
    get :index, board_id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create tag for given board" do
    expected_name = "New tag name"
    assert_difference('Tag.count') do
      post :create, board_id: @board.id, tag: {name: expected_name}
    end
    created_tag = assigns :tag
    assert_response :created
    assert_equal board_tag_url(@board.id, created_tag.id), @response.headers['Location']
    returned_tag = ActiveSupport::JSON.decode @response.body
    assert_equal created_tag.id, returned_tag['id']
    assert_equal created_tag.name, returned_tag['name']
    links = returned_tag['links']
    assert_equal 1, links.count
    self_link = links.select {|l| l['rel'] == 'self'}.first
    assert_equal board_tag_url(@board.id, created_tag.id), self_link['href']
    actual_tag = Tag.find created_tag.id
    assert_equal expected_name, actual_tag.name
    assert_equal @board.id, actual_tag.board.id
  end

  test "should return unprocessable_entity status when create a tag without name" do
    post :create, board_id: @board.id, tag: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when given board is not existed (POST)" do
    post :create, board_id: 99999, tag: {name: "New tag name"}
    assert_response :not_found
    assert_blank @response.body
  end

  test "should show tag" do
    get :show, board_id: @board.id, id: @tag1.id
    assert_response :success
    actual_tag = ActiveSupport::JSON.decode @response.body
    assert_equal @tag1.id, actual_tag['id']
    assert_equal @tag1.name, actual_tag['name']
    links = actual_tag['links']
    assert_equal 1, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal board_tag_url(@board.id, @tag1.id), self_link['href']
  end

  test "should return 404 Not Found when tag is not under given board (GET)" do
    get :show, board_id: @board2.id, id: @tag1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when section is not existed (GET)" do
    get :show, board_id: @board.id, id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update tag" do
    new_tag_name = "new tag name"
    put :update, board_id: @board.id, id: @tag1, tag: {name: new_tag_name}
    assert_response :no_content
    assert_blank @response.body
    actual_tag = Tag.find(@tag1.id)
    assert_equal new_tag_name, actual_tag.name
  end

  test "should return unprocessable_entity status when clear name of a tag" do
    put :update, board_id: @board.id, id: @tag1, tag: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when tag is not under given board (UPDATE)" do
    put :update, board_id: @board2.id, id: @tag1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when tag is not existed (UPDATE)" do
    put :show, board_id: @board.id, id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should delete existed tag but not associated ideas" do
    idea_ids = @tag1.ideas.collect { |i| i.id }
    tag_id = @tag1.id
    assert_difference('Tag.count', -1) do
      delete :destroy, board_id: @board.id, id: tag_id
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Tag.exists?(@tag1.id), "tag should be deleted"
    idea_ids.each { |id|
      assert_equal true, Idea.exists?(id), "Associated ideas should not be deleted."
      idea = Idea.find id
      assert_equal false, idea.tags.collect { |tag| tag.id }.include?(tag_id)
    }
  end

  test "should return 204 No Content when tag is not under given board (DELETE)" do
    delete :destroy, board_id: @board2, id: @tag1
    assert_response :no_content
    assert_blank @response.body
  end

  test "should return 204 No Content when tag is not existed (DELETE)" do
    delete :destroy, board_id: @board, id: 99999
    assert_response :no_content
    assert_blank @response.body
  end
end
