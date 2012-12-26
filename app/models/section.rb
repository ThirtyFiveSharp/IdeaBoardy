class Section < ActiveRecord::Base
  COLORS = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5']

  attr_accessible :name, :color
  has_many :ideas, order: 'vote desc, id asc', dependent: :destroy
  belongs_to :board

  validates :name, presence: true, uniqueness: {scope: :board_id, message: "section name should be unique in a board"}
  validates :color, inclusion: {in: COLORS, message: "%{value} is not a valid color, should be one of #{COLORS.join(", ")}"}

  after_initialize :default_value!

  scope :of_board, lambda { |board_id| where("board_id = ?", board_id).order("id") }

  private
  def default_value!
    self.color ||= COLORS[0]
  end
end
