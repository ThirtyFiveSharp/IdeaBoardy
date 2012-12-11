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
            {rel: 'merging', href: "#{board_section_idea_url(board_id, section_id, idea_id)}/merging"},
            {rel: 'tags', href: "#{board_section_idea_tags_url(board_id, section_id, idea_id)}"}
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
    Idea.delete(params[:id])
    head :no_content
  end

  def vote
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]
    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)
    @idea = Idea.find(idea_id)
    @idea.vote!
    if @idea.save
      head status: :no_content
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  def merging
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]
    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)

    idea = Idea.find(idea_id)
    source_idea = Idea.find(params[:source])
    idea.merge_with source_idea, params[:content]
    head :no_content
  end

  def tags
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:id]
    tag_ids = params[:tags]
    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)
    tag_ids.each { |tag_id|
      return head(:bad_request) unless Tag.of_board(board_id).exists?(tag_id)
    }

    idea = Idea.find(idea_id)
    idea.update_tags tag_ids
    head :no_content
  end
end
