require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  test "idea content should not be blank" do
    assert_raise "Idea content should not be blank", ActiveRecord::RecordInvalid do
      Idea.create!(content: "")
    end
  end

  test "idea content should not be nil" do
    assert_raise "Idea content should not be nil", ActiveRecord::RecordInvalid do
      Idea.create!(content: nil)
    end
  end

  test "default value of vote should be zero" do
    idea = Idea.new content: "Idea content"

    assert_equal 0, idea.vote, "default value of vote should be zero"
  end

  test "vote! should increase vote number by one" do
    existed_idea = Idea.create content: "Idea content"

    existed_idea = Idea.find existed_idea.id
    original_vote_number = existed_idea.vote
    existed_idea.vote!
    existed_idea.save!

    actual_idea = Idea.find existed_idea.id
    assert_equal original_vote_number + 1, actual_idea.vote, "vote! should increase vote number by one"
  end

end
