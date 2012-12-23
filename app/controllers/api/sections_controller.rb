module Api
  class SectionsController < ApiController
    respond_to :json

    def show
      section_id = params[:id]
      embeddable = get_embeddable(Section)
      section = Section.includes(embeddable).find(section_id)
      render json: build_representation(section, embeddable)
    end

    def update
      section_id = params[:id]
      section_properties = params[:section]
      section = Section.find(section_id)
      if section.update_attributes(section_properties)
        head :no_content
      else
        render json: section.errors, status: :unprocessable_entity
      end
    end

    def destroy
      section_id = params[:id]
      begin
        Section.destroy(section_id)
      rescue ActiveRecord::RecordNotFound
        # ignored
      end
      head :no_content
    end

    def immigration
      section_id = params[:id]
      section = Section.find(section_id)
      immigrant_idea_id = params[:source]
      begin
        immigrant_idea = Idea.find(immigrant_idea_id)
        immigrant_idea.section = section
        immigrant_idea.save!
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: {source: 'Immigrant idea does not exist.'}, status: :bad_request
      end
    end
  end
end