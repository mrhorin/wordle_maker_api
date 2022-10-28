class Api::V1::GamesController < ApplicationController
  before_action :set_game_by_params, except: [:index, :supported_langs, :current_user_index, :create]
  before_action :authenticate_api_v1_user!, except: [:index, :show, :supported_langs]
  before_action :authenticate_game_owner, except: [:index, :show, :supported_langs, :current_user_index, :create]
  before_action :check_published_game, except: [:index, :supported_langs, :current_user_index, :create, :update, :destroy]
  before_action :check_suspended_game, except: [:index, :supported_langs, :current_user_index, :create]
  before_action :check_suspended_current_user, except: [:index, :show, :supported_langs]

  def index
    games = Game.left_joins(:owner).where(is_suspended: false, is_published: true, owner: {is_suspended: false}).order(id: :desc).limit(10)
    render json: { ok: true, data: games, statusCode: 200 }, status: 200
  end

  def show
    if @game.present?
      render_game_owner_suspended if @game.owner.is_suspended
      render json: { ok: true, isSuspended: false, data: @game, statusCode: 200 }, status: 200
    else
      render_game_not_found
    end
  end

  def supported_langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

  # Authenticated user
  def current_user_index
    games = current_api_v1_user.games
    render json: { ok: true, isLoggedIn: true, isSuspended: false, message: "Succeeded.", data: games }, status: 200
  end

  def create
    game = Game.new(title: create_game_params[:title], desc: create_game_params[:desc], lang: create_game_params[:lang], char_count: create_game_params[:char_count], user_id: current_api_v1_user.id)
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
    # strong parameters
    def create_game_params
      params.require(:game).permit(:id, :title, :challenge_count, :char_count, :lang, :desc)
    end

    def update_game_params
      params.require(:game).permit(:id, :title, :desc, :challenge_count, :is_published)
    end

    # set
    def set_game_by_params
      @game = Game.find_by_id(params[:id])
    end

    # check
    def check_suspended_current_user
      render_current_user_suspended if current_api_v1_user.is_suspended
    end

    def check_suspended_game
      @game = Game.find_by_id(params[:id])
      render_game_not_found unless @game.present?
      render_game_suspended if @game.is_suspended || @game.owner.is_suspended
    end

    def check_published_game
      @game = Game.find_by_id(params[:id])
      render_game_not_found unless @game.present?
      unless @game.is_published
        if !api_v1_user_signed_in? || @game.owner != current_api_v1_user
          render_game_not_published
        end
      end
    end

    def authenticate_game_owner
      render_user_not_logged_in unless api_v1_user_signed_in?
      @game = Game.find_by_id(params[:id])
      render_game_not_owner unless @game.owner == current_api_v1_user
    end

    # render error json
    def render_user_not_logged_in
      render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('users.not_logged_in')}, status: 401
    end

    def render_current_user_suspended
      render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('users.is_suspended')}, status: 403
    end

    def render_game_not_owner
      render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('games.not_owner') }, status: 401
    end

    def render_game_not_found
      render json: { ok: false, isSuspended: false, statusCode: 404, message: I18n.t('games.not_found')}, status: 404
    end

    def render_game_not_published
      render json: { ok: false, isPublished: false, statusCode: 403, message: I18n.t('games.not_published') }, status: 403
    end

    def render_game_suspended
      render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('games.is_suspended')}, status: 403
    end

    def render_game_owner_suspended
      render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('games.owner_is_suspended')}, status: 403
    end
end
