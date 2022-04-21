class Api::V1::GamesController < ApplicationController
  include Pagination
  before_action :authenticate_api_v1_user!, except: [:show, :supported_langs]

  def supported_langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  def show
    game = Game.find_by_id(params[:id])
    if game.present?
      render json: { ok: true, data: game }, status: 200
    else
      render json: { ok: false, message: "Game ID #{params[:id]} Not Foundd" }, status: 404
    end
  end

  # Authenticated
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

  def update
    if api_v1_user_signed_in?
      game = Game.find_by_id(update_game_params[:id])
      if game.update(update_game_params)
        render json: { isLoggedIn: true, ok: true, message: "Updated.", data: game }, status: 200
      else
        render json: { isLoggedIn: true, ok: false, message: "The parameter is incorrect." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401
    end
  end

  def destroy
    if api_v1_user_signed_in?
      game = Game.find_by_id(params[:id])
      if game.destroy
        render json: { isLoggedIn: true, ok: true, message: "Deleted.", data: game }, status: 200
      else
        render json: { isLoggedIn: true, ok: false, message: "Failed." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401
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

  def subjects
    if api_v1_user_signed_in?
      game = Game.find_by_id(params[:id])
      if game.present?
        page = params[:page]
        per = params[:per].present? ? params[:per] : 20
        subjects_paginated = game.subjects.select(:id, :word).order(id: :desc).page(page).per(per)
        pagination = pagination(subjects_paginated)
        render json: { isLoggedIn: true, ok: true, data: {subjects: subjects_paginated, pagination: pagination} }, status: 200
      else
        render json: { isLoggedIn: true, ok: false, message: "Notfound" }, status: 404
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in."}, status: 401
    end
  end

  private
    def game_params
      params.require(:game).permit(:id, :title, :char_count, :lang, :desc)
    end

    def update_game_params
      params.require(:game).permit(:id, :title, :desc)
    end
end
