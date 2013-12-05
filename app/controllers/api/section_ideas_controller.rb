module Api
  class SectionIdeasController < ApiController
    respond_to :json

    def index
      section_id = params[:section_id]
      section = Section.includes(:ideas).find(section_id)
      render json: section.ideas.collect { |idea| {
          id: idea.id,
          content: idea.content,
          vote: idea.vote,
          links: [
              {rel: 'idea', href: api_idea_url(idea.id)}
          ]
      } }
    end

    def create
      section_id = params[:section_id]
      idea_properties = params[:section_idea]
      section = Section.find section_id
      idea = Idea.new(idea_properties)
      idea.section = section
      if idea.save
        @idea_id = idea.id
        head status: :created, location: api_idea_url(idea.id)
      else
        @idea_id = nil
        render json: idea.errors, status: :unprocessable_entity
      end
    end
  end
end