module Api
  class ConceptsController < ApplicationController
    respond_to :json

    def index
      render json: Concept.order('name').collect { |concept| {
          id: concept.id,
          name: concept.name,
          links: [
              {rel: :concept, href: api_concept_url(concept.id)}
          ]
      } }
    end

    def show
      concept_id = params[:id]
      concept = Concept.find(concept_id)
      render json: {
          id: concept.id,
          name: concept.name,
          links: [
              {rel: :self, href: api_concept_url(concept.id)},
              {rel: :tags, href: api_concept_tags_url(concept.id)}
          ]
      }
    end

    def update
      concept_id = params[:id]
      concept_properties = params[:concept]
      concept = Concept.find(concept_id)
      if concept.update_attributes(concept_properties)
        head :no_content
      else
        render json: concept.errors, status: :unprocessable_entity
      end
    end

    def destroy
      concept_id = params[:id]
      begin
        Concept.destroy(concept_id)
      rescue ActiveRecord::RecordNotFound
        #ignore
      end
      head :no_content
    end

    def tags
      concept_id = params[:id]
      tag_ids = params[:tags]
      tag_ids.each { |tag_id|
        return head(:bad_request) unless Tag.exists?(tag_id)
      }
      concept = Concept.find(concept_id)
      concept.update_tags tag_ids
      head :no_content
    end
  end
end
