class Idea < ActiveRecord::Base
  attr_accessible :content, :vote
  belongs_to :section
  after_initialize :default_value!

  validates :content, presence: true

  scope :of_section, lambda {|section_id| where("section_id = ?", section_id).order("vote desc")}

  def vote!
    self.vote += 1
  end

  private
  def default_value!
    self.vote ||= 0
  end
end
