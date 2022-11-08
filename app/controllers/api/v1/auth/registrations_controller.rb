class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Render
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  before_action :prevent_cookie_overflow, except: [:cancel, :new, :create, :update, :edit, ]
  before_action :check_suspended, except: [:cancel, :new, :create]

  private
    def prevent_cookie_overflow
      # Prevent ActionDispatch::Cookies::CookieOverflow
      session.delete("warden.user.user.key")
    end

    def check_suspended
      return render_current_user_suspended if @resource.is_suspended
    end
end
