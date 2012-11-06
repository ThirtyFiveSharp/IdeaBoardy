require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  setup do
     Section.delete_all
  end

  test "should add an idea" do
    section = Section.new name: "Section name"
    section.save

    idea = Idea.new content: "Idea content"
    section.ideas << idea

    actual_section = Section.find section.id
    assert_equal 1, actual_section.ideas.count
    assert_equal idea.id, actual_section.ideas.first.id
  end

  test "section name should be unique" do
    section_name = "Section name"
    Section.create name: section_name

    assert_raise "Section with duplicated name should not be created.", ActiveRecord::RecordInvalid do
      Section.create! name: section_name
    end
  end
end
