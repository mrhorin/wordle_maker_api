class Api::V1::GamesController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:langs]

  def langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  def create
    if api_v1_user_signed_in?
      game = Game.new(title: game_params[:title], lang: game_params[:language], char_count: game_params[:char_count], user_id: current_api_v1_user.id)
      if game.save
        render json: { isLoggedIn: true, ok: true, message: "succeeded.", data: game }, status: 201
      else
        render json: { isLoggedIn: true, ok: false, message: "The parameter is incorrect." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401
    end
  end

  private
    def game_params
      params.require(:game).permit(:title, :char_count, :language)
    end
end
