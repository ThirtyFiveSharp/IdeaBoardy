class SectionsController < ApplicationController
  def index
    board_id = params[:board_id]
    @sections = Section.find_all_by_board_id(board_id)

    render json: @sections.collect { |section| {
        id: section.id,
        name: section.name,
        links: [
            {rel: 'section', href: board_section_url(board_id, section.id)}
        ]
    } }
  end

  def show
    board_id = params[:board_id]
    section_id = params[:id]
    begin
      @section = Section.of_board(board_id).find(section_id)
      render json: {
          id: @section.id,
          name: @section.name,
          links: [
              {rel: 'self', href: board_section_url(board_id, section_id)},
              {rel: 'ideas', href: board_section_ideas_url(board_id, section_id)}
          ]
      }
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

  end

  def create
    @section = Section.new(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render json: @section, status: :created, location: @section }
      else
        format.html { render action: "new" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    board_id = params[:board_id]
    section_id = params[:id]
    begin
      @section = Section.of_board(board_id).find(section_id)
      if @section.update_attributes(params[:section])
        head :no_content
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end

  def destroy
    section_id = params[:id]
    begin
      @section = Section.find(section_id)
      @section.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :no_content
    end
  end
end
