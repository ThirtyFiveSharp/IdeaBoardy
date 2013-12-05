module Api
  class BoardSectionsController < ApiController
    respond_to :json

    def index
      board_id = params[:board_id]
      board = Board.includes(:sections).find(board_id)
      render json: board.sections.collect { |section| {
          id: section.id,
          name: section.name,
          links: [
              {rel: 'section', href: api_section_url(section.id)}
          ]
      } }
    end

    def create
      board_id = params[:board_id]
      section_properties = params[:board_section]
      board = Board.find board_id
      section = Section.new(section_properties)
      section.board = board
      if section.save
        @section_id = section.id
        head status: :created, location: api_section_url(section.id)
      else
        @section_id = nil
        render json: section.errors, status: :unprocessable_entity
      end
    end
  end
end