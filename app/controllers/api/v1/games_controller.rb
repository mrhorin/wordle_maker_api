class Api::V1::GamesController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:index, :show, :supported_langs]
  before_action :authenticate_owner, except: [:index, :show, :supported_langs, :current_user_index, :create]
  before_action :check_published_game, except: [:index, :supported_langs, :current_user_index, :create, :update, :destroy]
  before_action :check_suspended_game, except: [:index, :supported_langs, :current_user_index, :create]
  before_action :check_suspended_current_user, except: [:index, :show, :supported_langs]

  def index
    games = Game.where(is_suspended: false, is_published: true).order(id: :desc).limit(10)
    render json: { ok: true, data: games, statusCode: 200 }, status: 200
  end

  def show
    return render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('users.is_suspended')}, status: 403  if @game.owner.is_suspended
    if @game.present?
      render json: { ok: true, isSuspended: false, data: @game, statusCode: 200 }, status: 200
    else
      render json: { ok: false, isSuspended: false, message: I18n.t('games.not_found'), statusCode: 404 }, status: 404
    end
  end

  def supported_langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  # Authenticated user
  def current_user_index
    games = current_api_v1_user.games
    render json: { ok: true, isLoggedIn: true, isSuspended: false, message: "succeeded.", data: games }, status: 200
  end

  def create
    game = Game.new(title: game_params[:title], desc: game_params[:desc], lang: game_params[:lang], char_count: game_params[:char_count], user_id: current_api_v1_user.id)
    if game.save
      render json: { ok: true, isLoggedIn: true, message: "Created.", data: game }, status: 201
    else
      render json: { ok: false, isLoggedIn: true, message: "Failed" }, status: 500
    end
  end

  # Authenticated owner
  def update
    if @game.update(update_game_params)
      render json: { ok: true, isLoggedIn: true, isSuspended: false, message: "Updated.", data: @game }, status: 200
    else
      render json: { ok: false, isLoggedIn: true, isSuspended: false, message: "Failed." }, status: 500
    end
  end

  def destroy
    if @game.destroy
      render json: { ok: true, isLoggedIn: true, isSuspended: false, message: "Deleted.", data: @game }, status: 200
    else
      render json: { ok: false, isLoggedIn: true, isSuspended: false, message: "Failed." }, status: 500
    end
  end

  private
    def game_params
      params.require(:game).permit(:id, :title, :challenge_count, :char_count, :lang, :desc, :is_published)
    end

    def update_game_params
      params.require(:game).permit(:id, :title, :desc, :challenge_count, :is_published)
    end

    def authenticate_owner
      return render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('users.not_logged_in')}, status: 401 unless api_v1_user_signed_in?
      @game = Game.find_by_id(params[:id])
      return render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('games.not_owner') }, status: 401 unless @game.owner == current_api_v1_user
    end

    def check_suspended_current_user
      return render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('users.is_suspended')}, status: 403 if current_api_v1_user.is_suspended
    end

    def check_suspended_game
      @game = Game.find_by_id(params[:id])
      return render json: { ok: false, isSuspended: false, statusCode: 404, message: I18n.t('games.not_found')}, status: 404 unless @game.present?
      return render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('games.is_suspended')}, status: 403 if @game.is_suspended || @game.owner.is_suspended
    end

    def check_published_game
      @game = Game.find_by_id(params[:id])
      return render json: { ok: false, isSuspended: false, statusCode: 404, message: I18n.t('games.not_found')}, status: 404 unless @game.present?
      unless @game.is_published
        if !api_v1_user_signed_in? || @game.owner != current_api_v1_user
          return render json: { ok: false, isSuspended: @game.is_suspended, isPublished: false, statusCode: 403, message: I18n.t('games.not_published') }, status: 403
        end
      end
    end
end
