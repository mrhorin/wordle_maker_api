class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  def destroy
    # Prevent ActionDispatch::Cookies::CookieOverflow
    session.delete("warden.user.user.key")
    super
  end
end
