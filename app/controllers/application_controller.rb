class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Render
  before_action :skip_session

  protected
    def skip_session
      request.session_options[:skip] = true
    end
end
