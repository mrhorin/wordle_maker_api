class Api::V1::GamesController < ApplicationController
  include Pagination
  before_action :check_suspended_game, except: [:supported_langs, :list_current_games , :create]
  before_action :authenticate_api_v1_user!, except: [:show, :word_list, :supported_langs]
  before_action :authenticate_owner, only: [:update, :destroy, :words]

  def show
    if @game.present?
      render json: { ok: true, data: @game }, status: 200
    else
      render json: { ok: false, message: "Game ID #{params[:id]} is not found." }, status: 404
    end
  end

  def word_list
    game = Game.find_by_id(params[:id])
    if game.present?
      word_list = Rails.cache.fetch("word_list#{game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){game.word_list}
      render json: { ok: true, data: word_list }, status: 200
    else
      render json: { ok: false, message: "Game ID #{params[:id]} is not found" }, status: 404
    end
  end

  def supported_langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  # Authenticated user
  def list_current_games
    if api_v1_user_signed_in?
      games = current_api_v1_user.games
      render json: { isLoggedIn: true, ok: true, message: "succeeded.", data: games }, status: 200
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401
    end
  end

  def create
    if api_v1_user_signed_in?
      game = Game.new(title: game_params[:title], desc: game_params[:desc], lang: game_params[:lang], char_count: game_params[:char_count], user_id: current_api_v1_user.id)
      if game.save
        render json: { isLoggedIn: true, ok: true, message: "Created.", data: game }, status: 201
      else
        render json: { isLoggedIn: true, ok: false, message: "The parameter is incorrect." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401
    end
  end

  # Authenticated owner
  def update
    if @game.update(update_game_params)
      render json: { isLoggedIn: true, ok: true, message: "Updated.", data: @game }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: "The parameter is incorrect." }, status: 500
    end
  end

  def destroy
    if @game.destroy
      render json: { isLoggedIn: true, ok: true, message: "Deleted.", data: @game }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: "Failed." }, status: 500
    end
  end

  def words
    page = params[:page]
    per = params[:per].present? ? params[:per] : 50
    words_paginated = @game.words.select(:id, :name).order(id: :desc).page(page).per(per)
    pagination = pagination(words_paginated)
    render json: { isLoggedIn: true, ok: true, data: {words: words_paginated, pagination: pagination} }, status: 200
  end

  private
    def game_params
      params.require(:game).permit(:id, :title, :challenge_count, :char_count, :lang, :desc)
    end

    def update_game_params
      params.require(:game).permit(:id, :title, :desc, :challenge_count)
    end

    def authenticate_owner
      return render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401 unless api_v1_user_signed_in?
      @game = Game.find_by_id(params[:id])
      return render json: { isLoggedIn: false, ok: false, message: "You are not the owner of the game." }, status: 401 unless @game.present? && @game.owner == current_api_v1_user
    end

    def check_suspended_game
      @game = Game.find_by_id(params[:id])
      return render json: { ok: false, message: "This game is suspended for some reasons."}, status: 403 if @game.present? && @game.is_suspended
    end
end
