class Section < ActiveRecord::Base
  attr_accessible :name
  has_many :ideas, order: 'vote desc', dependent: :destroy
  belongs_to :board
  validates :name, presence:true, uniqueness: {scope: :board_id, message: "section name should be unique in a board"}

  scope :of_board, lambda {|board_id| where("board_id = ?", board_id)}
end
