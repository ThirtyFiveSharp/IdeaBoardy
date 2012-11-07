class IdeasController < ApplicationController
  # GET /ideas
  # GET /ideas.json
  respond_to :json

  def index
    @ideas = Idea.all
    render json: @ideas
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.find(params[:id])
    render json: @idea
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(params[:idea])
    section = Section.find params[:section_id]
    @idea.section = section

    if @idea.save
      render json: @idea, status: :created, location: board_section_idea_url(section.board.id, section.id, @idea.id)
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.json
  def update
    @idea = Idea.find(params[:id])

    if @idea.update_attributes(params[:idea])
      head :no_content
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    head :no_content
  end
end
