class Board < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :sections, order: 'id', dependent: :destroy
  validates :name, uniqueness: true, presence: true
end
