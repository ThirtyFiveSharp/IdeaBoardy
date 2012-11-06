class Board < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :sections
  validates :name, uniqueness: true
end
