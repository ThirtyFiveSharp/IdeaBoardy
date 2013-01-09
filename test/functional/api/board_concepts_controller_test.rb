require 'test_helper'

class Api::BoardConceptsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @board = boards(:board_one)
    @shape = concepts(:shape)
    @color = concepts(:color)
  end

  test "should get all concepts for the given board" do
    expected_concepts = [@color, @shape]
    get :index, board_id: @board.id
    assert_response :success
    actual_concepts = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_concepts.count, "should return all two concepts"
    expected_concepts.each_with_index do |expected_concept, index|
      assert_equal expected_concept.id, actual_concepts[index]['id']
      assert_equal expected_concept.name, actual_concepts[index]['name']
      links = actual_concepts[index]['links']
      assert_equal 1, links.count
      concept_link = links.select { |l| l['rel'] == 'concept' }.first
      assert_equal api_concept_url(expected_concept.id), concept_link['href']
    end
  end

  test "should return 404 Not Found when given board is not existed (INDEX)" do
    get :index, board_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create concept for the given board" do
    expected_name = "New concept name"
    assert_difference("Board.find(#{@board.id}).concepts.count") do
      post :create, board_id: @board.id, board_concept: {name: expected_name}
    end
    created_concept_id = assigns :concept_id
    assert_response :created
    assert_equal api_concept_url(created_concept_id), @response.headers['Location']

    returned_concept = ActiveSupport::JSON.decode @response.body
    assert_equal created_concept_id, returned_concept['id']
    assert_equal expected_name, returned_concept['name']
    links = returned_concept['links']
    assert_equal 2, links.count
    self_link = links.select { |l| l['rel'] == 'self' }.first
    assert_equal api_concept_url(created_concept_id), self_link['href']
    tags_link = links.select { |l| l['rel'] == 'tags' }.first
    assert_equal api_concept_tags_url(created_concept_id), tags_link['href']

    actual_concept = Concept.find created_concept_id
    assert_equal expected_name, actual_concept.name
    assert_equal @board.id, actual_concept.board.id
  end

  test "should return unprocessable_entity status when create a section without name" do
    post :create, board_id: @board.id, board_concept: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when the given board is not existed (POST)" do
    post :create, board_id: NON_EXISTED_ID, board_concept: {name: "New concept name"}
    assert_response :not_found
    assert_blank @response.body
  end
end