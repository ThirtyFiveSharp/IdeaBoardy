require 'test_helper'

class Api::ConceptsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @shape = concepts(:shape)
    @color = concepts(:color)
    @tag1 = tags(:tag_one)
    @square = tags(:square)
    @circle = tags(:circle)
  end

  test "should get all concepts" do
    expected_concepts = [@color, @shape]
    get :index
    assert_response :success
    actual_concepts = ActiveSupport::JSON.decode @response.body
    assert_equal expected_concepts.count, actual_concepts.count
    expected_concepts.each_with_index do |expected_concept, index|
      assert_equal expected_concept.id, actual_concepts[index]['id']
      assert_equal expected_concept.name, actual_concepts[index]['name']
      links = actual_concepts[index]['links']
      assert_equal 1, links.count
      concept_link = links.select { |l| l['rel'] == 'concept' }.first
      assert_equal api_concept_url(expected_concept.id), concept_link['href']
    end
  end

  test "should show concept" do
    get :show, id: @shape
    assert_response :success
    actual_concept = ActiveSupport::JSON.decode @response.body
    assert_equal @shape.id, actual_concept['id']
    assert_equal @shape.name, actual_concept['name']
    links = actual_concept['links']
    assert_equal 2, links.count
    self_link = links.select { |l| l['rel'] == 'self' }.first
    assert_equal api_concept_url(@shape.id), self_link['href']
    tags_link = links.select { |l| l['rel'] == 'tags' }.first
    assert_equal api_concept_tags_url(@shape.id), tags_link['href']
  end

  test "should return 404 Not Found when concept is not existed (GET)" do
    get :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update concept" do
    expected_name = "New concept name"
    put :update, id: @shape.id, concept: {name: expected_name}
    assert_response :no_content
    assert_blank @response.body
    actual_concept = Concept.find @shape.id
    assert_equal expected_name, actual_concept.name
  end

  test "should return unprocessable_entity status when clear name of a concept" do
    put :update, id: @shape.id, concept: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when concept is not existed (UPDATE)" do
    put :update, id: NON_EXISTED_ID, concept: {name: "new board name"}
    assert_response :not_found
    assert_blank @response.body
  end

  test "should delete existed concept but not associated tags" do
    tag_ids = @shape.tags.collect { |t| t.id }
    concept_id = @shape.id
    assert_difference('Concept.count', -1) do
      delete :destroy, id: concept_id
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Tag.exists?(@shape.id), "concept should be deleted"
    tag_ids.each { |tag_id|
      assert_equal true, Tag.exists?(tag_id), "Associated tags should not be deleted."
      tag = Tag.find tag_id
      assert_equal nil, tag.concept
    }
  end

  test "should return 204 No Content when concept is not existed (DELETE)" do
    delete :destroy, id: NON_EXISTED_ID
    assert_response :no_content
    assert_blank @response.body
  end

  test "should update tags of an concept" do
    expected_tags = [@circle, @square, @tag1]
    put :tags, id: @shape, tags: expected_tags.collect{|tag| tag.id}
    assert_response :no_content
    assert_blank @response.body
    actual_concept = Concept.find(@shape.id)
    assert_equal expected_tags.count, actual_concept.tags.count
    expected_tags.sort_by{|tag| tag.name}.each_with_index {|expected_tag, index|
      assert_equal expected_tag.id, actual_concept.tags[index].id
    }
  end

  test "should return 404 Not Found when idea is not existed (UPDATE TAGS)" do
    put :tags, id: NON_EXISTED_ID, tags: []
    assert_response :not_found
    assert_blank @response.body
  end
end
