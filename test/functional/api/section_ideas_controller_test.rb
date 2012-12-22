require 'test_helper'

class Api::SectionIdeasControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @section1 = sections(:section_one)
    @idea1 = ideas(:idea_one)
    @idea2 = ideas(:idea_two)
  end

  test "should get ideas for the given section" do
    get :index, section_id: @section1.id
    assert_response :success
    expected_ideas = [@idea2, @idea1]
    actual_ideas = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_ideas.count, "should return all two ideas"
    expected_ideas.each_with_index do |expected_idea, index|
      assert_equal expected_idea.id, actual_ideas[index]['id']
      assert_equal expected_idea.content, actual_ideas[index]['content']
      assert_equal expected_idea.vote, actual_ideas[index]['vote']
      links = actual_ideas[index]['links']
      assert_equal 1, links.count
      idea_link = links.select { |l| l['rel'] == 'idea' }.first
      assert_equal api_idea_url(expected_idea.id), idea_link['href']
    end
  end

  test "should return 404 Not Found when given section is not existed (INDEX)" do
    get :index, section_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create idea for given section" do
    expected_content = "New idea content"
    assert_difference("Idea.of_section(#{@section1.id}).count") do
      post :create, section_id: @section1.id, section_idea: {content: expected_content}
    end
    created_idea_id = assigns(:idea_id)
    assert_response :created
    assert_blank @response.body
    assert_equal api_idea_url(created_idea_id), @response.headers['Location']
    actual_idea = Idea.find created_idea_id
    assert_equal expected_content, actual_idea.content
    assert_equal 0, actual_idea.vote
    assert_equal @section1.id, actual_idea.section.id
  end

  test "should return unprocessable_entity status when create an idea without content" do
    post :create, section_id: @section1, section_idea: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["content"], "can't be blank"
  end

  test "should return 404 Not Found when given section is not existed (CREATE)" do
    get :create, section_id: NON_EXISTED_ID, section_idea: {content: 'Idea content'}
    assert_response :not_found
    assert_blank @response.body
  end
end
