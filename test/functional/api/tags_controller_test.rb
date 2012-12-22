require 'test_helper'

class Api::TagsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @tag1 = tags(:tag_one)
    @red = tags(:red)
  end

  test "should show tag with no associated concept" do
    get :show, id: @tag1.id
    assert_response :success
    actual_tag = ActiveSupport::JSON.decode @response.body
    assert_equal @tag1.id, actual_tag['id']
    assert_equal @tag1.name, actual_tag['name']
    links = actual_tag['links']
    assert_equal 1, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal api_tag_url(@tag1.id), self_link['href']
  end

  test "should show tag with associated concept" do
    get :show, id: @red.id
    assert_response :success
    actual_tag = ActiveSupport::JSON.decode @response.body
    assert_equal @red.id, actual_tag['id']
    assert_equal @red.name, actual_tag['name']
    links = actual_tag['links']
    assert_equal 2, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal api_tag_url(@red.id), self_link['href']
    concept_link = links.select { |l| l['rel']=='concept' }.first
    assert_equal api_concept_url(@red.concept.id), concept_link['href']
  end

  test "should return 404 Not Found when tag is not existed (GET)" do
    get :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update tag" do
    new_tag_name = "new tag name"
    put :update, id: @tag1, tag: {name: new_tag_name}
    assert_response :no_content
    assert_blank @response.body
    actual_tag = Tag.find(@tag1.id)
    assert_equal new_tag_name, actual_tag.name
  end

  test "should return unprocessable_entity status when clear name of a tag" do
    put :update, id: @tag1, tag: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when tag is not existed (UPDATE)" do
    put :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should delete existed tag but not associated ideas" do
    idea_ids = @tag1.ideas.collect { |i| i.id }
    tag_id = @tag1.id
    assert_difference('Tag.count', -1) do
      delete :destroy, id: tag_id
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

  test "should return 204 No Content when tag is not existed (DELETE)" do
    delete :destroy, id: NON_EXISTED_ID
    assert_response :no_content
    assert_blank @response.body
  end
end
