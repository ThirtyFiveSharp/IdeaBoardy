module Api
  class BoardConceptsController < ApiController
    respond_to :json

    def index
      board_id = params[:board_id]
      board = Board.includes(:sections).find(board_id)
      render json: board.concepts.collect { |concept| {
          id: concept.id,
          name: concept.name,
          links: [
              {rel: 'concept', href: api_concept_url(concept.id)}
          ]
      } }
    end

    def create
      board_id = params[:board_id]
      concept_properties = params[:board_concept]
      board = Board.find board_id
      concept = Concept.new(concept_properties)
      concept.board = board
      if concept.save
        @concept_id = concept.id
        render json: build_representation(concept), status: :created, location: api_concept_url(concept.id)
      else
        @concept_id = nil
        render json: concept.errors, status: :unprocessable_entity
      end
    end
  end
end