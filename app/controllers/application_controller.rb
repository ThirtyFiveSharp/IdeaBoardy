class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def record_not_found
    head :not_found
  end
end
