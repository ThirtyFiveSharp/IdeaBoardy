require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  setup do
    @board = boards(:one)
    @section = sections(:one)
    @idea1 = ideas(:one)
    @idea2 = ideas(:two)
  end

  test "should get index" do
    get :index, board_id: @board.id, section_id: @section.id
    assert_response :success
    expected_ideas = [@idea1, @idea2]
    actual_ideas = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_ideas.count, "should return all two ideas"
    expected_ideas.each_with_index do |expected_idea, index|
      assert_equal expected_idea.id, actual_ideas[index]['id']
      assert_equal expected_idea.content, actual_ideas[index]['content']
      assert_equal expected_idea.vote, actual_ideas[index]['vote']
      links = actual_ideas[index]['links']
      assert_equal 1, links.count
      idea_link = links.select {|l| l['rel'] == 'idea'}.first
      assert_equal board_section_idea_url(expected_idea.section.board.id, expected_idea.section.id, expected_idea.id), idea_link['href']
    end
  end

  test "should create idea" do
    expected_content = "New idea content"
    assert_difference('Idea.count') do
      post :create, board_id: @board.id, section_id: @section.id, idea: { content: expected_content }
    end
    created_idea = assigns(:idea)
    assert_response :created
    assert_equal board_section_idea_url(1,1,created_idea.id), @response.headers['Location']
    actual_idea = Idea.find created_idea.id
    assert_equal expected_content, actual_idea.content
    assert_equal 0, actual_idea.vote
  end

  test "should show idea" do
    get :show, board_id:@idea1.section.board.id, section_id:@idea1.section.id, id: @idea1.id
    assert_response :success
    actual_idea = ActiveSupport::JSON.decode @response.body
    assert_equal @idea1.id, actual_idea['id']
    assert_equal @idea1.content, actual_idea['content']
    assert_equal @idea1.vote, actual_idea['vote']
    links = actual_idea['links']
    assert_equal 1, links.count
    self_link = links.select {|l| l['rel'] == 'self'}.first
    assert_equal board_section_idea_url(@idea1.section.board.id, @idea1.section.id, @idea1.id), self_link['href']
  end

  test "should update idea" do
    expected_content = "New Content"
    put :update, board_id: @idea1.section.board.id, section_id: @idea1.section.id, id: @idea1.id, idea: { content: expected_content }
    assert_response :no_content
    actual_idea = Idea.find @idea1.id
    assert_equal expected_content, actual_idea.content, "should update content of the idea"
  end

  test "should destroy idea" do
    assert_difference('Idea.count', -1) do
      delete :destroy, board_id: @idea1.section.board.id, section_id: @idea1.section.id, id: @idea1.id
    end
    assert_response :no_content
    assert_equal false, Idea.exists?(@idea1.id), "idea should be deleted"
  end
end
