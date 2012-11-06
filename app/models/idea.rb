class Idea < ActiveRecord::Base
  attr_accessible :content, :vote
  belongs_to :section
  after_initialize :default_value!

  def vote!
    self.vote += 1
  end

  private
  def default_value!
    self.vote ||= 0
  end
end
