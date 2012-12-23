module Api
  class BoardsController < ApiController
    respond_to :json

    def index
      render json: Board.all.collect { |board| {
          id: board.id,
          name: board.name,
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

    def report
      board_id = params[:id]
      board = Board.includes(:sections => :ideas).find(board_id)
      board_report = board.report
      render json: board_report.merge(links(board))
    end

    private
    def links(board)
      report_link = Hash[rel: 'self', href: report_api_board_url(board.id)]
      board_link = Hash[rel: 'board', href: api_board_url(board.id)]
      share_link = Hash[rel: 'share', href: api_emails_share_url]
      Hash[links: [report_link, board_link, share_link]]
    end
  end
end