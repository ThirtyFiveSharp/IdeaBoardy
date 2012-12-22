module Api
  class TagsController < ApplicationController
    respond_to :json

    def show
      tag_id = params[:id]
      tag = Tag.find(tag_id)
      resource_links = [{rel: :self, href: api_tag_url(tag_id)}]
      resource_links << {rel: :concept, href: api_concept_url(tag.concept.id)} unless tag.concept.nil?
      render json: {
          id: tag.id,
          name: tag.name,
          links: resource_links
      }
    end

    def update
      tag_id = params[:id]
      tag_properties = params[:tag]
      tag = Tag.find(tag_id)
      if tag.update_attributes(tag_properties)
        head :no_content
      else
        render json: tag.errors, status: :unprocessable_entity
      end
    end

    def destroy
      tag_id = params[:id]
      begin
        Tag.destroy(tag_id)
      rescue ActiveRecord::RecordNotFound
        # ignored
      end
      head :no_content
    end
  end
end