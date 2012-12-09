require 'test_helper'

class IdeaTagsControllerTest < ActionController::TestCase
  setup do
    @board = boards(:board_one)
    @board2 = boards(:board_two)
    @section1 = sections(:section_one)
    @section2 = sections(:section_two)
    @idea1 = ideas(:idea_one)
    @tag1 = tags(:tag_one)
    @tag2 = tags(:tag_two)
  end

  test "should get index" do
    get :index, board_id: @board.id, section_id: @section1.id, idea_id: @idea1.id
    assert_response :success
    expected_tags = [@tag1, @tag2].sort_by{|tag| tag.name}
    actual_tags = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_tags.count, "should return all two tags"
    expected_tags.each_with_index do |expected_tag, index|
      assert_equal expected_tag.id, actual_tags[index]['id']
      assert_equal expected_tag.name, actual_tags[index]['name']
      links = actual_tags[index]['links']
      assert_equal 1, links.count
      tag_link = links.select { |l| l['rel'] == 'tag' }.first
      assert_equal board_tag_url(expected_tag.board.id, expected_tag.id), tag_link['href']
    end
  end

  test "should return 404 Not Found when section is not under given board (GET)" do
    get :index, board_id: @board2.id, section_id: @section1.id, idea_id: @idea1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when idea is not under given section (GET)" do
    get :index, board_id: @board.id, section_id: @section2.id, idea_id: @idea1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when idea is not existed (GET)" do
    get :index, board_id: @board.id, section_id: @section2.id, idea_id: 99999
    assert_response :not_found
    assert_blank @response.body
  end
end
