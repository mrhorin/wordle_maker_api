class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end