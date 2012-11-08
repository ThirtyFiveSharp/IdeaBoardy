class Section < ActiveRecord::Base
  attr_accessible :name
  has_many :ideas, dependent: :destroy
  belongs_to :board
  validates :name, uniqueness: {scope: :board_id, message: "section name should be unique in a board"}

  scope :of_board, lambda {|board_id| where("board_id = ?", board_id)}
end
