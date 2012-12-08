class SectionsController < ApplicationController
  respond_to :json

  def index
    board_id = params[:board_id]
    return head :not_found unless Board.exists?(board_id)

    @sections = Section.of_board(board_id)
    render json: @sections.collect { |section| {
        id: section.id,
        name: section.name,
        links: [
            {rel: 'section', href: board_section_url(board_id, section.id)}
        ]
    } }
  end

  def show
    board_id = params[:board_id]
    section_id = params[:id]
    @section = Section.of_board(board_id).find(section_id)
    render json: {
        id: @section.id,
        name: @section.name,
        color: @section.color,
        links: [
            {rel: 'self', href: board_section_url(board_id, section_id)},
            {rel: 'ideas', href: board_section_ideas_url(board_id, section_id)},
            {rel: 'immigration', href: "#{board_section_url(board_id, section_id)}/immigration"}
        ]
    }
  end

  def create
    board_id = params[:board_id]
    board = Board.find board_id
    @section = Section.new(params[:section])
    @section.board = board
    if @section.save
      head status: :created, location: board_section_url(board_id, @section.id)
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def update
    board_id = params[:board_id]
    section_id = params[:id]
    @section = Section.of_board(board_id).find(section_id)
    if @section.update_attributes(params[:section])
      head :no_content
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def destroy
    section_id = params[:id]
    begin
      @section = Section.find(section_id)
      @section.destroy
    rescue ActiveRecord::RecordNotFound
      # ignored
    end
    head :no_content
  end

  def immigration
    source_idea = Idea.find(params[:source])
    source_idea.section_id = params[:id]
    source_idea.save!
    head :no_content
  end
end
