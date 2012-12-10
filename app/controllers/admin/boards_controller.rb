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

  def import
    if(params[:file].nil?)
      flash[:alert] = "please select a yaml file for import!"
      redirect_to action: "index"
      return
    end
    import_boards(params[:file])
    flash[:notice] = "All board(s) imported successfully!"
    redirect_to action: "index"
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to action: "index"
  end

  private
  def import_boards(file)
    boards_yaml = YAML.load(file.read)
    boards_yaml.each do |board_yaml|
      import_board board_yaml
    end
  end

  def import_board(board_yaml)
    Board.transaction do
      board = Board.create!(name: board_yaml["name"], description: board_yaml["description"])
      board_yaml["sections"].each do |section_yaml|
        board.sections << import_section(section_yaml)
      end
      board.save!
    end
  end

  def import_section(section_yaml)
    section = Section.create!(name: section_yaml["name"], color: section_yaml["color"])
    section_yaml["ideas"].each do |idea_yaml|
      section.ideas << import_idea(idea_yaml)
    end
    section.save!
    section
  end

  def import_idea(idea_yaml)
    Idea.create!(content: idea_yaml["content"], vote: idea_yaml["vote"])
  end
end
