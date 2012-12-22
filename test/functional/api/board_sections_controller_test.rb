require 'test_helper'

class Api::BoardSectionsControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @board = boards(:board_one)
    @section1 = sections(:section_one)
    @section2 = sections(:section_two)
  end

  test "should get all sections for the given board" do
    expected_sections = [@section1, @section2].sort_by { |section| section.id }
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
      assert_equal api_section_url(expected_section.id), section_link['href']
    end
  end

  test "should return 404 Not Found when given board is not existed (INDEX)" do
    get :index, board_id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should create section for the given board" do
    expected_name = "New section name"
    assert_difference("Section.of_board(#{@board.id}).count") do
      post :create, board_id: @board.id, board_section: {name: expected_name, color: Section::COLORS[3]}
    end
    created_section_id = assigns :section_id
    assert_response :created
    assert_equal api_section_url(created_section_id), @response.headers['Location']
    assert_blank @response.body
    actual_section = Section.find created_section_id
    assert_equal expected_name, actual_section.name
    assert_equal @board.id, actual_section.board.id
    assert_equal Section::COLORS[3], actual_section.color
  end

  test "should return unprocessable_entity status when create a section without name" do
    post :create, board_id: @board.id, board_section: {}
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["name"], "can't be blank"
  end

  test "should return 404 Not Found when the given board is not existed (POST)" do
    post :create, board_id: NON_EXISTED_ID, board_section: {name: "New section name"}
    assert_response :not_found
    assert_blank @response.body
  end
end