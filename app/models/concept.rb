class Concept < ActiveRecord::Base
  attr_accessible :name
  belongs_to :board
  has_many :tags, order: 'name'

  validates :name, presence: true

  def update_tags(tag_ids)
    transaction do
      self.tags.clear
      self.tags = Tag.where(id: tag_ids)
      self.save!
    end
  end
end
