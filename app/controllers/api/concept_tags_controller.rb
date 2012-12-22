module Api
  class ConceptTagsController < ApplicationController
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

    def create
      board_id = params[:board_id]
      tag_properties = params[:board_tag]
      board = Board.find board_id
      tag = Tag.new(tag_properties)
      tag.board = board
      if tag.save
        @tag_id = tag.id
        tag_uri = api_tag_url(tag.id)
        render status: :created, location: tag_uri, json: {
            id: tag.id,
            name: tag.name,
            links: [
                {rel: 'self', href: tag_uri}
            ]
        }
      else
        @tag_id = nil
        render json: tag.errors, status: :unprocessable_entity
      end
    end
  end
end