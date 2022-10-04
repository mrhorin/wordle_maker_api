# https://github.com/lynndylanhurley/devise_token_auth/blob/master/app/controllers/devise_token_auth/omniauth_callbacks_controller.rb
class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

  def redirect_callbacks
    super
  end

  # 認証成功時
  def omniauth_success
    super
    update_auth_header
  end

  # 認証失敗時
  def omniauth_failure
    super
  end

  protected
  def render_data_or_redirect message, data, user_data = {}
    url = "#{Rails.configuration.app[:URL][:UI][:PROTOCOL]}://#{Rails.configuration.app[:URL][:UI][:DOMAIN]}/"
    redirect_to DeviseTokenAuth::Url.generate(url, data.merge(blank: true))
  end

  def get_resource_from_auth_hash
    super
    @resource.name = strip_emoji(@resource.name)
    @resource.nickname = strip_emoji(@resource.nickname)
    @resource
  end

  def strip_emoji str
    str.encode('SJIS', 'UTF-8', invalid: :replace, undef: :replace, replace: '').encode('UTF-8')
  end

end
