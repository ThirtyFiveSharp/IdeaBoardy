class Tag < ActiveRecord::Base
  attr_accessible :name
  belongs_to :board
  belongs_to :concept
  has_and_belongs_to_many :ideas

  validates :name, presence:true, uniqueness: {scope: :board_id, message: "tag name should be unique in a board"}

  scope :of_board, lambda {|board_id| where("board_id = ?", board_id).order("name asc")}
end
