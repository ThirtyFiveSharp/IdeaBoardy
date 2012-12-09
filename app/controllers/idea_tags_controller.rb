class IdeaTagsController < ApplicationController
  respond_to :json

  def index
    board_id = params[:board_id]
    section_id = params[:section_id]
    idea_id = params[:idea_id]

    return head(:not_found) unless Section.of_board(board_id).exists?(section_id)
    return head(:not_found) unless Idea.of_section(section_id).exists?(idea_id)

    render json: Idea.find(idea_id).tags.collect {|tag|
      {
          id: tag.id,
          name: tag.name,
          links: [
              {rel: 'tag', href: board_tag_url(board_id, tag.id)}
          ]
      }
    }
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

end
