class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :skip_session

  private
    # Users
    def render_current_user_suspended
      render json: { ok: false, httpStatus: 403, code: 1001, message: I18n.t('users.is_suspended')}, status: 403
    end

    def render_user_not_logged_in
      render json: { ok: false, httpStatus: 401, code: 1002, message: I18n.t('users.not_logged_in')}, status: 401
    end

    # Games
    def render_game_not_found
      render json: { ok: false, httpStatus: 404, code: 2001, message: I18n.t('games.not_found')}, status: 404
    end

    def render_game_no_words
      render json: { ok: false, httpStatus: 404, code: 2002, message: I18n.t('games.has_no_words') }, status: 404
    end

    def render_game_not_published
      render json: { ok: false, httpStatus: 403, code: 2003, message: I18n.t('games.not_published') }, status: 403
    end

    def render_game_suspended
      render json: { ok: false, httpStatus: 403, code: 2004, message: I18n.t('games.is_suspended')}, status: 403
    end

    def render_game_owner_suspended
      render json: { ok: false, httpStatus: 403, code: 2005, message: I18n.t('games.owner_is_suspended')}, status: 403
    end

    def render_game_not_owner
      render json: { ok: false, httpStatus: 401, code: 2006, message: I18n.t('games.not_owner') }, status: 401
    end

    # Word
    def render_word_not_found
      render json: { ok: false, httpStatus: 404, code: 3001, message: I18n.t('words.not_found')}, status: 404
    end

  protected
    def skip_session
      request.session_options[:skip] = true
    end
end
