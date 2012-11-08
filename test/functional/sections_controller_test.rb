require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @board = boards(:one)
    @board2 = boards(:two)
    @section1 = sections(:one)
    @section2 = sections(:two)
  end

  test "should get index" do
    expected_sections = [@section1, @section2]
    get :index, board_id: @board.id
    assert_response :success
    actual_sections = ActiveSupport::JSON.decode @response.body
    assert_equal 2, actual_sections.count, "should return all two sections"
    expected_sections.each_with_index do |expected_section, index|
      assert_equal expected_section.id, actual_sections[index]['id']
      assert_equal expected_section.name, actual_sections[index]['name']
      links = actual_sections[index]['links']
      assert_equal 1, links.count
      section_link = links.select {|l| l['rel'] == 'section'}.first
      assert_equal board_section_url(expected_section.board.id, expected_section.id), section_link['href']
    end
  end

  test "should return 404 Not Found when section is not under given board (GET)" do
    get :show, board_id:@board2.id, id: @section1.id
    assert_response :not_found
  end

  test "should update section" do
    new_section_name = "new section name"
    put :update, board_id: @board.id, id: @section1, section: { name: new_section_name}

    assert_response :no_content
    actual_section = Section.find(@section1.id)
    assert_equal new_section_name, actual_section.name
  end

  test "should return 404 Not Found when section is not under given board (UPDATE)" do
    get :update, board_id:@board2.id, id: @section1.id
    assert_response :not_found
  end

  test "should delete existed section and associated ideas" do
    idea_ids = @section1.ideas.collect {|i| i.id}
    assert_difference('Section.count', -1) do
      delete :destroy, board_id: @board.id, id: @section1
    end
    assert_response :no_content
    assert_equal false, Section.exists?(@section1.id), "section should be deleted"
    idea_ids.each {|id| assert_equal false, Idea.exists?(id), "Associated ideas should be deleted."}
  end

  test "should return 204 No Content when section is not under given board (DELETE)" do
    delete :destroy, board_id: @board2, id: @section1
    assert_response :no_content
  end

  test "should return 204 No Content when section is not existed" do
    delete :destroy, board_id: @board, id: 99999
    assert_response :no_content
  end

end
