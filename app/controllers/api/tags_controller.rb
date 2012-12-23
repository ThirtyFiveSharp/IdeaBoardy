module Api
  class TagsController < ApiController
    respond_to :json

    def show
      tag_id = params[:id]
      embeddable = get_embeddable(Tag)
      tag = Tag.includes(embeddable).find(tag_id)
      representation = build_representation(tag, embeddable)
      render json: representation
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