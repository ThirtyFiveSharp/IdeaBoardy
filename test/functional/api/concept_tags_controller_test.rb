require 'test_helper'

class Api::ConceptTagsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @shape = concepts(:shape)
    @square = tags(:square)
    @circle = tags(:circle)
  end

  test "should get tags for the given concept" do
    expected_tags = [@circle, @square]
    get :index, concept_id: @shape.id
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
    get :index, concept_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end
end
