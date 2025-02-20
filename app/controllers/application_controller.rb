class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :exception

  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: -> {request.format.json?}
end
