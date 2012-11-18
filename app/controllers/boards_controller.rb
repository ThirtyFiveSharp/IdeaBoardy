class BoardsController < ApplicationController
  respond_to :json

  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all

    render json: @boards.collect { |board| {
        id: board.id,
        name: board.name,
        links: [
            {rel: 'board', href: board_url(board.id)}
        ]
    } }
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    until_found do
      @board = Board.find(params[:id])
      render json: {
          id: @board.id,
          name: @board.name,
          description: @board.description,
          links: [
              {rel: 'self', href: board_url(@board.id)},
              {rel: 'sections', href: board_sections_url(@board.id)},
              {rel: 'report', href: "#{board_url(@board.id)}/report"}
          ]
      }
    end
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(params[:board])

    if @board.save
      head status: :created, location: board_url(@board.id)
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    until_found do
      @board = Board.find(params[:id])
      if @board.update_attributes(params[:board])
        head :no_content
      else
        render json: @board.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    until_found :no_content do
      @board = Board.find(params[:id])
      @board.destroy
      head :no_content
    end
  end

  # GET /boards/1/report
  def report
    until_found do
      @board = Board.includes(:sections => :ideas).find(params[:id])
      render json: {
          name: @board.name,
          description: @board.description,
          sections: @board.sections.collect { |section| {
              name: section.name,
              ideas: section.ideas.collect { |idea| {
                  content: idea.content,
                  vote: idea.vote
              } }
          } },
          links: [
              {rel: 'self', href: "#{board_url(@board.id)}/report"},
              {rel: 'board', href: board_url(@board.id)}
          ]
      }
    end
  end
end
