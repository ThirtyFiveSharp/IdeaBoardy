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
    until_found do
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
  end

  def create
    until_found do
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
  end

  def update
    board_id = params[:board_id]
    section_id = params[:id]
    until_found do
      @section = Section.of_board(board_id).find(section_id)
      if @section.update_attributes(params[:section])
        head :no_content
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    section_id = params[:id]
    until_found :no_content do
      @section = Section.find(section_id)
      @section.destroy
      head :no_content
    end
  end

  def immigration
    source_idea = Idea.find(params[:source])
    source_idea.section_id = params[:id]
    source_idea.save!
    head :no_content
  end
end
