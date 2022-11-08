class Api::V1::GamesController < ApplicationController
  before_action :set_game_by_params, except: [:index, :current_user_index, :create]
  before_action :authenticate_api_v1_user!, except: [:play, :index, :show, ]
  before_action :authenticate_owner, except: [:play, :index, :show,  :current_user_index, :create]
  before_action :check_suspended_current_user, except: [:play, :index, :show ]
  before_action :check_not_found, except: [:index, :current_user_index, :create]
  before_action :check_suspended, except: [:index, :current_user_index, :create]

  def play
    is_private = !@game.is_published && @game.owner != current_api_v1_user
    has_no_words = @game.words.blank?
    if is_private || has_no_words
      data = {
        game: @game,
        wordList: [],
        wordToday: "",
        questionNo: 0,
        isPrivate: is_private,
        hasNoWords: has_no_words
      }
      return render json: { ok: true, statusCode: 200, data: data }, status: 200
    else
      today = Rails.cache.fetch("words_today#{@game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){
        question = @game.questions.find_or_create_today
        question.word.present? && question.no.present? ? question : nil
      }
      data = {
        game: @game,
        wordList: @game.word_list,
        wordToday: today.word.name,
        questionNo: today.no,
        isPrivate: is_private ,
        hasNoWords: has_no_words
      }
      return render json: { ok: true, statusCode: 200, data: data }, status: 200
    end
  end

  def index
    games = Game.left_joins(:owner).where(is_suspended: false, is_published: true, owner: {is_suspended: false}).order(id: :desc).limit(10)
    render json: { ok: true, data: games, statusCode: 200 }, status: 200
  end

  def show
    render json: { ok: true, isSuspended: false, data: @game, statusCode: 200 }, status: 200
  end

  # Authenticated user
  def current_user_index
    games = current_api_v1_user.games
    render json: { ok: true, isLoggedIn: true, isSuspended: false, message: "Succeeded.", data: games }, status: 200
  end

  def create
    game = Game.new(
      title: create_game_params[:title],
      desc: create_game_params[:desc],
      lang: create_game_params[:lang],
      char_count: create_game_params[:char_count],
      user_id: current_api_v1_user.id
    )
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
      @game ||= Game.find_by_id(params[:id])
    end

    # authenticate
    def authenticate_owner
      return render_user_not_logged_in if !api_v1_user_signed_in?
      set_game_by_params
      return render_game_not_found if @game.blank?
      return render_game_not_owner if @game.owner != current_api_v1_user
    end

    # check
    def check_suspended_current_user
      return render_current_user_suspended if current_api_v1_user.is_suspended
    end

    def check_not_found
      set_game_by_params
      return render_game_not_found if @game.blank?
    end

    def check_suspended
      set_game_by_params
      return render_game_not_found if @game.blank?
      return render_game_suspended if @game.is_suspended || @game.owner.is_suspended
    end
end
