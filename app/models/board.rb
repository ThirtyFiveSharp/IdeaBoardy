class Board < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :sections, dependent: :destroy
  validates :name, uniqueness: true, presence: true
end
