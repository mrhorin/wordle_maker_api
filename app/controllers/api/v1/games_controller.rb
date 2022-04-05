class Api::V1::GamesController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:supported_langs]

  def supported_langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  # Authenticated
  def create
    if api_v1_user_signed_in?
      game = Game.new(title: game_params[:title], desc: game_params[:desc], lang: game_params[:language], char_count: game_params[:char_count], user_id: current_api_v1_user.id)
      if game.save
        render json: { isLoggedIn: true, ok: true, message: "succeeded.", data: game }, status: 201
      else
        render json: { isLoggedIn: true, ok: false, message: "The parameter is incorrect." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401
    end
  end

  def list_current_games
    if api_v1_user_signed_in?
      games = current_api_v1_user.games
      render json: { isLoggedIn: true, ok: true, message: "succeeded.", data: games }, status: 200
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401
    end
  end

  private
    def game_params
      params.require(:game).permit(:title, :char_count, :language, :desc)
    end
end
