class TagsController < ApplicationController
  respond_to :json

  def index
    board_id = params[:board_id]
    return head :not_found unless Board.exists?(board_id)

    @tags = Tag.of_board board_id

    render json: @tags.collect { |tag|
      {
          id: tag.id,
          name: tag.name,
          links: [
              {rel: 'tag', href: board_tag_url(board_id, tag.id)}
          ]
      }
    }
  end

  def create
    board_id = params[:board_id]
    board = Board.find board_id
    @tag = Tag.new(params[:tag])
    @tag.board = board
    if @tag.save
      head status: :created, location: board_tag_url(board_id, @tag.id)
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def show
    board_id = params[:board_id]
    tag_id = params[:id]
    @tag = Tag.of_board(board_id).find(tag_id)
    render json: {
        id: @tag.id,
        name: @tag.name,
        links: [
            {rel: 'self', href: board_tag_url(board_id, tag_id)}
        ]
    }
  end

  def update
    board_id = params[:board_id]
    tag_id = params[:id]
    @tag = Tag.of_board(board_id).find(tag_id)
    if @tag.update_attributes(params[:tag])
      head :no_content
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    tag_id = params[:id]
    @section = Tag.find(tag_id)
    @section.destroy
    head :no_content
  end
end
