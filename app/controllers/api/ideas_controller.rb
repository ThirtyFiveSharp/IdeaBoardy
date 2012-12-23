module Api
  class IdeasController < ApiController
    respond_to :json

    def show
      idea_id = params[:id]
      embeddable = get_embeddable(Idea)
      idea = Idea.includes(embeddable).find(idea_id)
      render json: build_representation(idea, embeddable)
    end

    def update
      idea_id = params[:id]
      idea = Idea.find(idea_id)
      idea_properties = params[:idea]
      if idea.update_attributes(idea_properties)
        head :no_content
      else
        render json: idea.errors, status: :unprocessable_entity
      end
    end

    def destroy
      idea_id = params[:id]
      Idea.delete(idea_id)
      head :no_content
    end

    def vote
      idea_id = params[:id]
      idea = Idea.find(idea_id)
      idea.vote!
      if idea.save
        head status: :no_content
      else
        render json: idea.errors, status: :unprocessable_entity
      end
    end

    def merging
      idea_id = params[:id]
      source_idea_id = params[:source]
      idea = Idea.find(idea_id)
      begin
        source_idea = Idea.find(source_idea_id)
        idea.merge_with source_idea, params[:content]
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: {source: 'Source idea does not exist.'}, status: :bad_request
      end
    end

    def tags
      idea_id = params[:id]
      tag_ids = params[:tags]
      tag_ids.each { |tag_id|
        return head(:bad_request) unless Tag.exists?(tag_id)
      }
      idea = Idea.find(idea_id)
      idea.update_tags tag_ids
      head :no_content
    end
  end
end