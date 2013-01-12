module Api
  class BoardsController < ApiController
    respond_to :json

    def index
      render json: Board.order('name').collect { |board| {
          id: board.id,
          name: board.name,
          shortenUrlCode: get_shorten_url("api_board", board.id),
          links: [
              {rel: 'board', href: api_board_url(board.id)}
          ]
      } }
    end

    def show
      board_id = params[:id]
      embeddable = get_embeddable(Board)
      board = Board.includes(embeddable).find(board_id)
      render json: build_representation(board, embeddable)
    end

    def create
      board_properties = params[:board]
      board = Board.new(board_properties)
      if board.save
        @board_id = board.id
        head status: :created, location: api_board_url(board.id)
      else
        @board_id = nil
        render json: board.errors, status: :unprocessable_entity
      end
    end

    def update
      board_id = params[:id]
      board_properties = params[:board]
      board = Board.find(board_id)
      if board.update_attributes(board_properties)
        head :no_content
      else
        render json: board.errors, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        board_id = params[:id]
        Board.destroy(board_id)
      rescue ActiveRecord::RecordNotFound
        # ignored
      end
      head :no_content
    end

  end
end