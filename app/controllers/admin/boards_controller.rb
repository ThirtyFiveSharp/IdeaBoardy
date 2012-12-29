class Admin::BoardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assert_selected_boards_exist, :only => :download
  before_filter :assert_file_selected, :only => :upload
  layout 'admin'

  def export
    boards = Board.includes(:tags, :concepts, :sections => :ideas).all
    @boards = []
    boards.each do |board|
      total_ideas_count = board.sections.collect { |section| section.ideas.length }.sum
      @boards << {:id => board.id,
                  :name => board.name,
                  :total_tags_count => board.tags.length,
                  :total_concepts_count => board.concepts.length,
                  :total_sections_count => board.sections.length,
                  :total_ideas_count => total_ideas_count}
    end
  end

  def import
  end

  def download
    boards = Board.includes(:tags, :concepts => :tags, :sections => {:ideas => :tags}).where(:id => params[:boards])
    boards_json = boards.to_json(:include => [:tags,
                                              {:concepts => {:include => :tags}},
                                              {:sections => {:include => {:ideas => {:include => :tags}}}}])
    yaml = ActiveSupport::JSON.decode(boards_json).to_yaml.encode('UTF-8')
    send_data yaml, :filename => "boards.yml"
  end

  def upload
    upload_boards(params[:file])
    flash[:notice] = "All board(s) imported successfully!"
    redirect_to action: "export"
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to action: "import"
  rescue
    flash[:alert] = "Invalid yaml file!"
    redirect_to action: "import"
  end

  private
  def assert_selected_boards_exist
    unless Board.all_exists?(params[:boards])
      flash[:alert] = "board(s) not found"
      redirect_to action: "export"
    end
  end

  def assert_file_selected
    if (params[:file].nil?)
      flash[:alert] = "please select a yaml file for import!"
      redirect_to action: "import"
    end
  end

  def upload_boards(file)
    Board.transaction do
      boards_yaml = YAML.load(file.read)
      boards_yaml.each do |board_yaml|
        upload_board board_yaml
      end
    end
  end

  def upload_board(board_yaml)
    board = Board.create!(name: board_yaml["name"], description: board_yaml["description"])
    board_yaml["tags"].each do |tag_yaml|
      board.tags << upload_tag(tag_yaml)
    end
    board_yaml["concepts"].each do |concept_yaml|
      board.concepts << upload_concept(board, concept_yaml)
    end
    board_yaml["sections"].each do |section_yaml|
      board.sections << upload_section(board, section_yaml)
    end
    board.save!
  end

  def upload_tag(tag_yaml)
    Tag.create!(name: tag_yaml["name"])
  end

  def upload_concept(board, concept_yaml)
    concept = Concept.create!(name: concept_yaml["name"])
    concept_yaml["tags"].each do |concept_tag_yaml|
      concept.tags << board.tag_named(concept_tag_yaml["name"])
    end
    concept.save!
    concept
  end

  def upload_section(board, section_yaml)
    section = Section.create!(name: section_yaml["name"], color: section_yaml["color"])
    section_yaml["ideas"].each do |idea_yaml|
      section.ideas << upload_idea(board, idea_yaml)
    end
    section.save!
    section
  end

  def upload_idea(board, idea_yaml)
    idea = Idea.create!(content: idea_yaml["content"], vote: idea_yaml["vote"])
    idea_yaml["tags"].each do |idea_tag_yaml|
      idea.tags << board.tag_named(idea_tag_yaml["name"])
    end
    idea.save!
    idea
  end

end
