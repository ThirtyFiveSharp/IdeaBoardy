class Idea < ActiveRecord::Base
  attr_accessible :content, :vote
  belongs_to :section
  has_and_belongs_to_many :tags, order: 'name'
  after_initialize :default_value!

  validates :content, presence: true

  scope :of_section, lambda { |section_id| where("section_id = ?", section_id).order("vote desc, id asc") }

  def vote!
    self.vote += 1
  end

  def merge_with(other_idea, merged_content)
    self.content = merged_content
    self.vote += other_idea.vote
    transaction do
      other_idea.delete
      self.save!
    end
  end

  def update_tags(tag_ids)
    transaction do
      self.tags.clear
      self.tags = Tag.where(id: tag_ids)
      self.save!
    end
  end

  private
  def default_value!
    self.vote ||= 0
  end
end
