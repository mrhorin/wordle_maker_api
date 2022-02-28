class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  protect_from_forgery
  before_action :skip_session
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  protected
  def skip_session
    request.session_options[:skip] = true
  end
end
