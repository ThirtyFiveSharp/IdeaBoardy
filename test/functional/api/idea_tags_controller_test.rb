require 'test_helper'

class Api::IdeaTagsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @idea1 = ideas(:idea_one)
    @tag1 = tags(:tag_one)
    @tag2 = tags(:tag_two)
  end

  test "should get tags for the given idea" do
    get :index, idea_id: @idea1.id
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
      assert_equal api_tag_url(expected_tag.id), tag_link['href']
    end
  end

  test "should return 404 Not Found when idea is not existed (GET)" do
    get :index, idea_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end
end
