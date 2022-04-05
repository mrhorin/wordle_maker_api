class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, except: []

  # Authenticated
  def current
    if api_v1_user_signed_in?
      render json: { isLoggedIn: true, data: current_api_v1_user }, status: 200
    else
      render json: { isLoggedIn: false, message: "You are not logged in."}, status: 404
    end
  end
end
