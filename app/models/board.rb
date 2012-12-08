class Board < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :sections, order: 'id', dependent: :destroy
  validates :name, uniqueness: true, presence: true

  def report
    Hash[name: name, description: description,
         sections: sections.collect { |section| section.report }]
  end
end
