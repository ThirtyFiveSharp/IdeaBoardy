module Api
  class TagCloudController < ApiController
    include TagCloud

    respond_to :json

    def index
      board_id = params[:board_id]
      tag_cloud = TagCloud.new board_id
      tag_cloud.analyze_segment_result
      render json: tag_cloud.get_analysis_result
    end
  end
end