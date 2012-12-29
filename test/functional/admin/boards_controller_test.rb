require 'test_helper'

class Admin::BoardsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_one)
    @board = boards(:board_one)
    sign_in @user
  end

  test "should get index" do
    expected_boards = Board.all
    get :export
    assert_response :success
    actual_boards = assigns(:boards)
    assert_equal expected_boards.count, actual_boards.count
    expected_boards.each_with_index do |board, index|
      assert_equal board.id, actual_boards[index][:id]
      assert_equal board.name, actual_boards[index][:name]
      assert_equal board.sections.count, actual_boards[index][:total_sections_count]
      assert_equal board.concepts.count, actual_boards[index][:total_concepts_count]
      assert_equal board.tags.count, actual_boards[index][:total_tags_count]
      assert_equal board.sections.sum { |section| section.ideas.count }, actual_boards[index][:total_ideas_count]
    end
  end

  test "should export boards to yaml data" do
    get :download, boards: [@board.id]

    yaml = YAML.load(@response.body)
    assert_equal 1, yaml.count
    actual_board = yaml[0]
    assert_equal @board.name, actual_board["name"]
    assert_equal @board.description, actual_board["description"]
    actual_tags = actual_board["tags"]
    assert_equal @board.tags.count, actual_tags.count
    @board.tags.each_with_index do |tag, index|
      assert_equal tag.name, actual_tags[index]["name"]
    end
    actual_concepts = actual_board["concepts"]
    assert_equal @board.sections.count, actual_concepts.count
    @board.concepts.each_with_index do |concept, index|
      assert_equal concept.name, actual_concepts[index]["name"]
      actual_concept_tags = actual_concepts[index]["tags"]
      assert_equal concept.tags.count, actual_concept_tags.count
      concept.tags.each_with_index do |tag, index|
        assert_equal tag.name, actual_concept_tags[index]["name"]
      end
    end
    actual_sections = actual_board["sections"]
    assert_equal @board.sections.count, actual_sections.count
    @board.sections.each_with_index do |section, index|
      assert_equal section.name, actual_sections[index]["name"]
      assert_equal section.color, actual_sections[index]["color"]
      actual_ideas = actual_sections[index]["ideas"]
      assert_equal section.ideas.count, actual_ideas.count
      section.ideas.each_with_index do |idea, index|
        assert_equal idea.content, actual_ideas[index]["content"]
        assert_equal idea.vote, actual_ideas[index]["vote"]
        actual_idea_tags = actual_ideas[index]["tags"]
        assert_equal idea.tags.count, actual_idea_tags.count
        idea.tags.each_with_index do |tag, index|
          assert_equal tag.name, actual_idea_tags[index]["name"]
        end
      end
    end
  end

  test "should alert 'board(s) not found' and redirect to export when board not found before export" do
    get :download, boards: [-1]
    assert_equal "board(s) not found", flash[:alert]
    assert_redirected_to :action => "export"
  end

  test "should alert 'please select a yaml file for import!' and redirect to import when no file is selected for import" do
    post :upload
    assert_equal "please select a yaml file for import!", flash[:alert]
    assert_redirected_to :action => "import"
  end

  test "should alert 'Invalid yaml file!' and redirect to import when no file is selected for import" do
    post :upload, file: fixture_file_upload("boards.yml")

    assert_equal "Invalid yaml file!", flash[:alert]
    assert_redirected_to :action => "import"
  end

  test "should alert invalid message when importing board already exist" do
    Board.create!(name: "exported_board", description: "exported_board")

    post :upload, file: fixture_file_upload("/files/exported_boards")

    assert_equal "Validation failed: Name has already been taken", flash[:alert]
    assert_redirected_to :action => "import"
  end

  test "should import board(s) not existed" do
    exported_file = fixture_file_upload("/files/exported_boards")
    post :upload, file: exported_file

    assert_response 302
    assert_redirected_to :action => "export"
    board_yaml = YAML.load_file(exported_file)[0]
    imported_board = Board.where('name = ?', board_yaml["name"]).first
    assert_equal board_yaml["name"], imported_board.name
    assert_equal board_yaml["description"], imported_board.description

    assert_equal board_yaml["tags"].count, imported_board.tags.count
    board_yaml["tags"].each_with_index do |tag_yaml, tag_index|
      tag = imported_board.tags[tag_index]
      assert_equal tag_yaml["name"], tag.name
    end

    assert_equal board_yaml["concepts"].count, imported_board.concepts.count
    board_yaml["concepts"].each_with_index do |concept_yaml, concept_index|
      concept = imported_board.concepts[concept_index]
      assert_equal concept_yaml["name"], concept.name
      assert_equal concept_yaml["tags"].count, concept.tags.count
      concept_yaml["tags"].each_with_index do |tag_yaml, tag_index|
        assert_equal tag_yaml["name"], concept.tags[tag_index].name
      end
    end

    assert_equal board_yaml["sections"].count, imported_board.sections.count
    board_yaml["sections"].each_with_index do |section_yaml, section_index|
      section = imported_board.sections[section_index]
      assert_equal section_yaml["name"], section.name
      assert_equal section_yaml["color"], section.color
      assert_equal section_yaml["ideas"].count, section.ideas.count
      section_yaml["ideas"].each_with_index do |idea_yaml, idea_index|
        idea = section.ideas[idea_index]
        assert_equal idea_yaml["content"], idea.content
        assert_equal idea_yaml["vote"], idea.vote
        assert_equal idea_yaml["tags"].count, idea.tags.count
        idea_yaml["tags"].each_with_index do |tag_yaml, tag_index|
          assert_equal tag_yaml["name"], idea.tags[tag_index].name
        end
      end
    end
  end
end
