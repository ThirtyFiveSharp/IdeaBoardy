require 'test_helper'

class TagCloudTest < ActiveSupport::TestCase

  include TagCloud

  setup do
    Board.delete_all
    Section.delete_all
    Tag.delete_all
    Idea.delete_all
    self.create_board()
  end

  def create_board
    @board = Board.new name: "Board name"
    @board.save

    @section = Section.new name: "Section name"
    @board.sections << @section

    @idea = Idea.new content: "Idea content"
    @idea.vote = 5
    @section.ideas << @idea

    @tag = Tag.new name: "tag name"
    @idea.tags << @tag
  end

  test "should convert a board to idea list" do
    tag_cloud = TagCloud.new @board.id
    idea_list = tag_cloud.get_idea_list
    assert_equal "Idea content", idea_list[0].content
    assert_equal 5, idea_list[0].vote
    assert_equal "Section name", idea_list[0].section_name
    assert_equal "Board name", idea_list[0].board_name
  end

  test "should convert an idea to one line text" do
    tag_cloud = TagCloud.new @board.id
    assert_equal "Idea content\nIdea content\nIdea content\nIdea content\nIdea content\nIdea content\nIdea content\n", tag_cloud.to_s
  end

  test "should segment board content" do
    tag_cloud = TagCloud.new @board.id
    words = tag_cloud.get_segment_result
    assert_equal "IDEA", words[0]['word']
    assert_equal "CONTENT", words[1]['word']
  end

  test "should statistic words frequency" do
    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    assert_equal 7, tag_cloud.word_frequency_hash['IDEA']
    assert_equal 7, tag_cloud.word_frequency_hash['CONTENT']
  end

  test "should return a word list as analysis result" do
    idea = Idea.new content: "add a content here"
    @section.ideas << idea

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    analysis_result = tag_cloud.get_analysis_result
    assert_equal "CONTENT", analysis_result[0]['name']
    assert_equal 9, analysis_result[0]['weight']
  end
end