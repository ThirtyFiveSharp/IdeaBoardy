require 'test_helper'

class ConceptTest < ActiveSupport::TestCase
  test "should add an tag" do
    concept = Concept.new name: "Concept name"
    concept.save

    tag = Tag.new name: "Tag name"
    concept.tags << tag

    actual_concept = Concept.find concept.id
    assert_equal 1, actual_concept.tags.count
    assert_equal tag.id, actual_concept.tags.first.id
  end

  test "concept should have name" do
    assert_raise "Concept should have name", ActiveRecord::RecordInvalid do
      Concept.create!(name: "")
    end
  end

  test "should raise ActiveRecord::StaleObjectError when update already modified concept" do
    concept_name = "concept_for_optimistic_lock"
    Concept.create!(name: concept_name)
    concept1 = Concept.find_by_name(concept_name)
    concept2 = Concept.find_by_name(concept_name)
    concept1.name = "concept1"
    concept1.save!
    assert_raise "not allowed to update already modified concept", ActiveRecord::StaleObjectError do
      concept2.name = "concept2"
      concept2.save!
    end
  end

  test "should destroy concept but not associated tags" do
    tag = Tag.new name: "Tag Name"
    tag.save
    concept = Concept.new name: "Concept Name"
    concept.tags << tag
    concept.save

    concept.destroy

    assert_equal false, Concept.exists?(concept.id)
    assert_equal true, Tag.exists?(tag.id)
    actual_tag = Tag.find(tag.id)
    assert_nil actual_tag.concept
  end
end
