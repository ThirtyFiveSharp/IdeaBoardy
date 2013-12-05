module Api
  class BoardTagsController < ApiController
    respond_to :json

    def index
      board_id = params[:board_id]
      board = Board.includes(:tags).find(board_id)
      render json: board.tags.collect { |tag| {
          id: tag.id,
          name: tag.name,
          links: [
              {rel: 'tag', href: api_tag_url(tag.id)}
          ]
      } }
    end

    def create
      board_id = params[:board_id]
      tag_properties = params[:board_tag]
      board = Board.find board_id
      tag = Tag.new(tag_properties)
      tag.board = board
      if tag.save
        @tag_id = tag.id
        tag_uri = api_tag_url(tag.id)
        render status: :created, location: tag_uri, json: {
            id: tag.id,
            name: tag.name,
            links: [
                {rel: 'self', href: tag_uri}
            ]
        }
      else
        @tag_id = nil
        render json: tag.errors, status: :unprocessable_entity
      end
    end
  end
end