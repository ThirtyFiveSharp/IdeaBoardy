require 'test_helper'

class Api::SectionsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @board = boards(:board_one)
    @board2 = boards(:board_two)
    @section1 = sections(:section_one)
    @section2 = sections(:section_two)
    @idea1 = ideas(:idea_one)
  end

  test "should show section" do
    get :show, id: @section1.id
    assert_response :success
    actual_section = ActiveSupport::JSON.decode @response.body
    assert_equal @section1.id, actual_section['id']
    assert_equal @section1.name, actual_section['name']
    assert_equal @section1.color, actual_section['color']
    links = actual_section['links']
    assert_equal 3, links.count
    self_link = links.select { |l| l['rel']=='self' }.first
    assert_equal api_section_url(@section1.id), self_link['href']
    ideas_link = links.select { |l| l['rel']=='ideas' }.first
    assert_equal api_section_ideas_url(@section1.id), ideas_link['href']
    immigration_link = links.select { |l| l['rel']=='immigration' }.first
    assert_equal "#{immigration_api_section_url(@section1.id)}", immigration_link['href']
  end

  test "should return 404 Not Found when section is not existed (GET)" do
    get :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update section" do
    new_section_name = "new section name"
    put :update, id: @section1, section: {name: new_section_name}
    assert_response :no_content
    assert_blank @response.body
    actual_section = Section.find(@section1.id)
    assert_equal new_section_name, actual_section.name
  end

  test "should return unprocessable_entity status when clear name of a section" do
    put :update, id: @section1, section: {name: ""}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when section is not existed (UPDATE)" do
    put :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should delete existed section and associated ideas" do
    idea_ids = @section1.ideas.collect { |i| i.id }
    assert_difference('Section.count', -1) do
      delete :destroy, id: @section1
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Section.exists?(@section1.id), "section should be deleted"
    idea_ids.each { |id| assert_equal false, Idea.exists?(id), "Associated ideas should be deleted." }
  end

  test "should return 204 No Content when section is not existed (DELETE)" do
    delete :destroy, id: NON_EXISTED_ID
    assert_response :no_content
    assert_blank @response.body
  end

  test "should move an immigrant idea into the section" do
    assert_difference('Idea.of_section(@section2).count') do
      post :immigration, id: @section2, source: @idea1.id
    end
    assert_response :no_content
    assert_blank @response.body
  end

  test "should return 404 Not Found when section is not existed (Immigration)" do
    post :immigration, id: NON_EXISTED_ID, source: @idea1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 400 Bad Request when immigrant idea is not existed (Immigration)" do
    post :immigration, id: @section2, source: NON_EXISTED_ID
    assert_response :bad_request
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["source"], "Immigrant idea does not exist."
  end
end
