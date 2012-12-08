require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    Board.delete_all
    Section.delete_all
    Idea.delete_all
    Tag.delete_all
  end

  test "should add an tag" do
    board = Board.create name: "Board name"
    section = Section.new name: "Section name"
    section.board = board
    section.save
    idea = Idea.new content: "Idea content"
    idea.section = section
    idea.save

    tag_name = "Tag name"
    tag = Tag.new name: tag_name
    tag.board = board
    tag.save!
    idea.tags << tag
    idea.save!

    actual_tag = Tag.find tag.id
    assert_equal tag_name, actual_tag.name
    assert_equal 1, actual_tag.ideas.count
    assert_equal idea.id, actual_tag.ideas.first.id
    actual_idea = Idea.find idea.id
    assert_equal 1, actual_idea.tags.count
    assert_equal tag.id, actual_idea.tags.first.id
  end

  test "tag name should be unique under the same board" do
    board = Board.create(name: "Board name")
    tag_name = "Tag name"
    tag = Tag.new(name: tag_name)
    tag.board = board
    tag.save!

    assert_raise "Tag with duplicated name should not be created.", ActiveRecord::RecordInvalid do
      tag = Tag.new(name: tag_name)
      tag.board = board
      tag.save!
    end
  end
end
