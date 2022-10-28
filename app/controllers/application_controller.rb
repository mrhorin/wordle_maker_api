class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :skip_session

  private
    # Users
    def render_user_not_logged_in
      render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('users.not_logged_in')}, status: 401
    end

    def render_current_user_suspended
      render json: { ok: false, isSuspended: true, statusCode: 403, message: I18n.t('users.is_suspended')}, status: 403
    end

    # Games
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

    def render_game_not_owner
      render json: { ok: false, isLoggedIn: false, statusCode: 401, message: I18n.t('games.not_owner') }, status: 401
    end

    def render_game_no_words
      render json: { ok: false, message: I18n.t('games.has_no_words') }, status: 404
    end

    # Word
    def render_word_not_found
      render json: { ok: false, message: I18n.t('words.not_found')}, status: 404
    end


  protected
    def skip_session
      request.session_options[:skip] = true
    end
end
