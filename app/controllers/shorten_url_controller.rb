class ShortenUrlController < ApplicationController
  include ShortenUrl

  def get
    origin_url = get_origin_url(params[:shortenUrlCode], request.query_string)
    if origin_url.nil?
      head :not_found
    else
      redirect_to origin_url, status: :see_other
    end
  end
end