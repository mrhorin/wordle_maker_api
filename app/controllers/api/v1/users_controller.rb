class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, except: []

  # Authenticated
  def current
    if api_v1_user_signed_in?
      render json: { ok: true, data: current_api_v1_user }, status: 200
    else
      render_user_not_logged_in
    end
  end
end
