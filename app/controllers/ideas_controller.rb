class IdeasController < ApplicationController
  respond_to :json

  def index
    board_id = params[:board_id]
    section_id = params[:section_id]

    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)

    @ideas = Idea.of_section(section_id)
    render json: @ideas.collect { |idea| {
        id: idea.id,
        content: idea.content,
        vote: idea.vote,
        links: [
            {rel: 'idea', href: board_section_idea_url(board_id, section_id, idea.id)}
        ]
    } }
  end

  def show
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]

    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)

    @idea = Idea.find(idea_id)
    render json: {
        id: @idea.id,
        content: @idea.content,
        vote: @idea.vote,
        links: [
            {rel: 'self', href: board_section_idea_url(board_id, section_id, idea_id)},
            {rel: 'vote', href: "#{board_section_idea_url(board_id, section_id, idea_id)}/vote"},
            {rel: 'merging', href: "#{board_section_idea_url(board_id, section_id, idea_id)}/merging"}
        ]
    }
  end

  def create
    board_id = params[:board_id]
    section_id = params[:section_id]

    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)

    @idea = Idea.new(params[:idea])
    section = Section.find section_id
    @idea.section = section

    if @idea.save
      head status: :created, location: board_section_idea_url(board_id, section_id, @idea.id)
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  def update
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]
    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)
    @idea = Idea.find(idea_id)
    if @idea.update_attributes(params[:idea])
      head :no_content
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  def destroy
    until_found :no_content do
      @idea = Idea.find(params[:id])
      @idea.destroy
      head :no_content
    end
  end

  def vote
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]
    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)
    until_found do
      @idea = Idea.find(idea_id)
      @idea.vote!
      if @idea.save
        head status: :no_content
      else
        render json: @idea.errors, status: :unprocessable_entity
      end
    end
  end

  def merging
    source_idea = Idea.find(params[:source])
    idea = Idea.find(params[:id])
    idea.content = params[:content]
    idea.vote += source_idea.vote
    Idea.transaction do
      source_idea.delete
      idea.save!
    end
    head :no_content
  end
end
