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

  test "should segment board content" do
    tag_cloud = TagCloud.new @board.id
    idea_list = tag_cloud.get_segment_result
    assert_equal "IDEA", idea_list[0]['segmentResult'][0]['word']
    assert_equal "CONTENT", idea_list[0]['segmentResult'][1]['word']
  end

  test "should statistic words frequency" do
    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    assert_equal 6, tag_cloud.word_frequency_hash['IDEA']
    assert_equal 6, tag_cloud.word_frequency_hash['CONTENT']
  end

  test "should statistic words idea frequency" do
    idea = Idea.new content: "add a content here"
    @section.ideas << idea

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    assert_equal 1, tag_cloud.word_idea_freq_hash['IDEA']
    assert_equal 2, tag_cloud.word_idea_freq_hash['CONTENT']
  end

  test "should filter useless words in analysis result" do
    idea = Idea.new content: "add a content here"
    @section.ideas << idea

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    analysis_result = tag_cloud.get_analysis_result
    assert_nil analysis_result.index{|x| x['name'] == 'IDEA'}
  end

  test "should return a word list as analysis result" do
    idea = Idea.new content: "add a content here"
    @section.ideas << idea

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    analysis_result = tag_cloud.get_analysis_result
    assert_equal "CONTENT", analysis_result[0]['name']
    assert_equal 7, analysis_result[0]['weight']
  end

  test "should word list which max size is 20" do
    idea = Idea.new content: "The first three forms set the selected elements of self (which may be the entire array) to obj. A start of nil is equivalent to zero. A length of nil is equivalent to self.length. The last three forms fill the array with the value of the block. The block is passed the absolute index of each element to be filled. Negative values of start count from the end of the array."
    @section.ideas << idea

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    analysis_result = tag_cloud.get_analysis_result
    assert_equal 20, analysis_result.size
  end

  test "should find phrase in ideas" do
    idea1 = Idea.new content: "integration pipeline still trigger by manual"
    idea2 = Idea.new content: "How to help team to figure out myTaxes & Tiger integration pipeline?"
    @section.ideas << idea1
    @section.ideas << idea2

    tag_cloud = TagCloud.new @board.id
    tag_cloud.analyze_segment_result
    analysis_result = tag_cloud.get_analysis_result
    assert_equal "INTEGR PIPELIN", analysis_result[0]['name']
  end
end