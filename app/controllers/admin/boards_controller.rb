class Admin::BoardsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  def index
    boards = Board.includes(:sections => :ideas).all
    @boards = []
    boards.each do |board|
      total_ideas_count = board.sections.sum { |section| section.ideas.count }
      @boards << {:id => board.id,
                  :name => board.name,
                  :total_sections_count => board.sections.count,
                  :total_ideas_count => total_ideas_count}
    end
  end
end
