require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  setup do
    @board = boards(:one)
    @section = sections(:one)
    @idea1 = ideas(:one)
    @idea2 = ideas(:two)
    @ideas = [@idea1, @idea2]
  end

  test "should get index" do
    get :index, board_id: 1, section_id: 1
    assert_response :success
    ideas = assigns(:ideas)
    assert_equal 2, ideas.count, "should return all two ideas"
    ideas.each_with_index do |idea, index|
      assert_equal @ideas[index], idea
    end
  end

  test "should create idea" do
    expected_content = "New idea content"
    assert_difference('Idea.count') do
      post :create, board_id: 1, section_id: 1, idea: { content: expected_content }
    end
    created_idea = assigns(:idea)
    assert_response :created
    assert_equal board_section_idea_url(1,1,created_idea.id), @response.headers['Location']
    actual_idea = Idea.find created_idea.id
    assert_equal expected_content, actual_idea.content
    assert_equal 0, actual_idea.vote
  end

  test "should show idea" do
    get :show, board_id:1, section_id:1, id: @idea1.id
    assert_response :success
    actual_idea = assigns(:idea)
    assert_equal @idea1, actual_idea
  end

  test "should update idea" do
    expected_content = "New Content"
    put :update, board_id: 1, section_id: 1, id: @idea1.id, idea: { content: expected_content }
    assert_response :no_content
    actual_idea = Idea.find @idea1.id
    assert_equal expected_content, actual_idea.content, "should update content of the idea"
  end

  test "should destroy idea" do
    assert_difference('Idea.count', -1) do
      delete :destroy, board_id: 1, section_id: 1, id: @idea1.id
    end
    assert_response :no_content
    assert_equal false, Idea.exists?(@idea1.id), "idea should be deleted"
  end
end
