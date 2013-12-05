module Api
  class IdeaTagsController < ApiController
    respond_to :json

    def index
      idea_id = params[:idea_id]
      idea = Idea.includes(:tags).find(idea_id)
      render json: idea.tags.collect {|tag|
        {
            id: tag.id,
            name: tag.name,
            links: [
                {rel: 'tag', href: api_tag_url(tag.id)}
            ]
        }
      }
    end
  end
end