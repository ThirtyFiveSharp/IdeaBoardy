class Board < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :sections, order: 'id', dependent: :destroy
  has_many :concepts, order: 'name', dependent: :destroy
  has_many :tags, order: 'name', dependent: :destroy
  validates :name, uniqueness: true, presence: true

  def report
    Hash[name: name, description: description,
         sections: sections.collect { |section| section.report }]
  end

  class << self
    def all_exists?(ids)
      self.find(ids)
      true
    rescue ActiveRecord::RecordNotFound
      false
    end
  end
end
