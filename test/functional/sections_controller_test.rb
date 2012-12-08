require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @board = boards(:one)
    @board2 = boards(:two)
    @section1 = sections(:one)
    @section2 = sections(:two)
    @idea1 = ideas(:one)
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
      section_link = links.select { |l| l['rel'] == 'section' }.first
      assert_equal board_section_url(expected_section.board.id, expected_section.id), section_link['href']
    end
  end

  test "should return 404 Not Found when given board is not existed (INDEX)" do
    get :index, board_id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create section for given board" do
    expected_name = "New section name"
    assert_difference('Section.count') do
      post :create, board_id: @board.id, section: {name: expected_name, color: Section::COLORS[3]}
    end
    created_section = assigns :section
    assert_response :created
    assert_equal board_section_url(@board.id, created_section.id), @response.headers['Location']
    assert_blank @response.body
    actual_section = Section.find created_section.id
    assert_equal expected_name, actual_section.name
    assert_equal @board.id, actual_section.board.id
    assert_equal Section::COLORS[3], actual_section.color
  end

  test "should return unprocessable_entity status when create a section without name" do
    post :create, board_id: @board.id, section: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when given board is not existed (POST)" do
    post :create, board_id: 99999, section: {name: "New section name"}
    assert_response :not_found
    assert_blank @response.body
  end

  test "should show section" do
    get :show, board_id: @board.id, id: @section1.id
    assert_response :success
    actual_section = ActiveSupport::JSON.decode @response.body
    assert_equal @section1.id, actual_section['id']
    assert_equal @section1.name, actual_section['name']
    assert_equal @section1.color, actual_section['color']
    links = actual_section['links']
    assert_equal 3, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal board_section_url(@board.id, @section1.id), self_link['href']
    ideas_link = links.select { |l| l['rel']=='ideas' }.first
    assert_equal board_section_ideas_url(@board.id, @section1.id), ideas_link['href']
    immigration_link = links.select { |l| l['rel']=='immigration' }.first
    assert_equal "#{board_section_url(@board.id, @section1.id)}/immigration", immigration_link['href']
  end

  test "should return 404 Not Found when section is not under given board (GET)" do
    get :show, board_id: @board2.id, id: @section1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when section is not existed (GET)" do
    get :show, board_id: @board.id, id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update section" do
    new_section_name = "new section name"
    put :update, board_id: @board.id, id: @section1, section: {name: new_section_name}
    assert_response :no_content
    assert_blank @response.body
    actual_section = Section.find(@section1.id)
    assert_equal new_section_name, actual_section.name
  end

  test "should return unprocessable_entity status when clear name of a section" do
    put :update, board_id: @board.id, id: @section1, section: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when section is not under given board (UPDATE)" do
    put :update, board_id: @board2.id, id: @section1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 404 Not Found when section is not existed (UPDATE)" do
    put :show, board_id: @board.id, id: 99999
    assert_response :not_found
    assert_blank @response.body
  end

  test "should delete existed section and associated ideas" do
    idea_ids = @section1.ideas.collect { |i| i.id }
    assert_difference('Section.count', -1) do
      delete :destroy, board_id: @board.id, id: @section1
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Section.exists?(@section1.id), "section should be deleted"
    idea_ids.each { |id| assert_equal false, Idea.exists?(id), "Associated ideas should be deleted." }
  end

  test "should return 204 No Content when section is not under given board (DELETE)" do
    delete :destroy, board_id: @board2, id: @section1
    assert_response :no_content
    assert_blank @response.body
  end

  test "should return 204 No Content when section is not existed (DELETE)" do
    delete :destroy, board_id: @board, id: 99999
    assert_response :no_content
    assert_blank @response.body
  end

  test "should move an idea into the section" do
    assert_difference('Idea.of_section(@section2).count') do
      post :immigration, board_id: @board, id: @section2, source: @idea1.id
    end
    assert_response :no_content
    assert_blank @response.body
  end
end
