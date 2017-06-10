class ApplicationController < ActionController::Base
  include Monban::ControllerHelpers
  include Pundit

  protect_from_forgery with: :exception

  def authenticate_user
    redirect_to new_session_path unless current_user.present?
  end
end
