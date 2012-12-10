class Admin::BoardsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  def index
    boards = Board.includes(:sections => :ideas).all
    @boards = []
    boards.each do |board|
      total_ideas_count = board.sections.collect { |section| section.ideas.length }.sum
      @boards << {:id => board.id,
                  :name => board.name,
                  :total_sections_count => board.sections.length,
                  :total_ideas_count => total_ideas_count}
    end
  end

  def export
    if !Board.all_exists?(params[:boards])
      flash[:alert] = "board(s) not found"
      redirect_to action: "index"
      return
    end
    boards = Board.includes(:sections => :ideas).where(:id => params[:boards])
    boards_json = boards.to_json(:include => {:sections => {:include => :ideas}})
    send_data ActiveSupport::JSON.decode(boards_json).to_yaml, :filename => "boards.yml"
  end
end
