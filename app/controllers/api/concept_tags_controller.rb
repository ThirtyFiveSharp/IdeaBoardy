module Api
  class ConceptTagsController < ApiController
    respond_to :json

    def index
      concept_id = params[:concept_id]
      concept = Concept.includes(:tags).find(concept_id)
      render json: concept.tags.collect { |tag| {
          id: tag.id,
          name: tag.name,
          links: [
              {rel: 'tag', href: api_tag_url(tag.id)}
          ]
      } }
    end
  end
end