class ApplicationController < ActionController::Base
  protect_from_forgery

  def until_found(response_when_not_found = :not_found, &block)
    begin
      block.call
    rescue ActiveRecord::RecordNotFound
      head response_when_not_found
    end
  end
end
