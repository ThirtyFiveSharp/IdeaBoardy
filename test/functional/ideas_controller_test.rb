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
    assert_difference('Idea.count') do
      post :create, board_id: 1, section_id: 1, idea: { content: "New idea content"}
    end
    created_idea = assigns(:idea)
    assert_response :created
    assert_equal board_section_idea_url(1,1,created_idea.id), @response.headers['Location']
  end

  #test "should show idea" do
  #  get :show, id: @idea
  #  assert_response :success
  #end
  #
  #test "should update idea" do
  #  put :update, id: @idea, idea: { content: @idea.content, vote: @idea.vote }
  #  assert_redirected_to idea_path(assigns(:idea))
  #end
  #
  #test "should destroy idea" do
  #  assert_difference('Idea.count', -1) do
  #    delete :destroy, id: @idea
  #  end
  #
  #  assert_redirected_to ideas_path
  #end
end
