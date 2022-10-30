class Api::V1::WordsController < ApplicationController
  include Pagination
  include WordsHelper
  before_action :set_game, except: [:update, :destroy]
  before_action :set_word, except: [:index, :today, :create, :edit, :destroy]
  before_action :authenticate_api_v1_user!, except: [:index, :today]
  before_action :authenticate_owner, except: [:index, :today, :create, :edit, :destroy]

  def index
    word_list = Rails.cache.fetch("words_index#{@game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){
      @game.word_list.present? ? @game.word_list : nil
    }
    if word_list.present?
      render json: { ok: true, data: word_list }, status: 200
    else
      render_game_no_words
    end
  end

  def today
    today = Rails.cache.fetch("words_today#{@game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){
      question = @game.questions.find_or_create_today
      question.word.present? && question.no.present? ? question : nil
    }
    if today.present? && today.word.present? && today.no.present?
      render json: { ok: true, data: { word: today.word, questionNo: today.no} }, status: 200
    else
      render_game_no_words
    end
  end

  # Authenticated user
  def create
    render_game_not_owner if @game.owner != current_api_v1_user
    invalid_words = []
    create_word_list_params.each do |item|
      word = @game.words.build(name: item.upcase)
      invalid_words << word unless word.save
    end
    if invalid_words.length == 0
      render json: { isLoggedIn: true, ok: true, message: "All of the words have been created successfully." }, status: 201
    elsif create_word_list_params.length > invalid_words.length
      render json: { isLoggedIn: true, ok: true, message: "The words have been created successfully, but some of them were failed.", data: invalid_words }, status: 207
    else
      render json: { isLoggedIn: true, ok: false, message: "The words are failed." }, status: 500
    end
  end

  # Authenticated owner
  def edit
    render_game_not_owner if @game.owner != current_api_v1_user
    edit_params = parse_edit_params params
    words_paginated = @game.words.select(:id, :name).order(edit_params[:sort] => edit_params[:order]).page(edit_params[:page]).per(edit_params[:per])
    pagination = pagination(words_paginated)
    render json: { ok: true, isLoggedIn: true, isSuspended: false, data: {words: words_paginated, pagination: pagination} }, status: 200
  end

  def update
    if @word.update(update_word_params.to_h.transform_values{|v| v.is_a?(String) ? v.upcase : v})
      render json: { isLoggedIn: true, ok: true, message: "Updated.", data: @word }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: @word.errors.messages, data: @word }, status: 500
    end
  end

  def destroy
    ids = params[:id].split(",").map{|s| s.to_i }
    authenticated_words = Word.left_joins(:game).where(id: ids, game: {user_id: current_api_v1_user})
    if authenticated_words.destroy_all
      render json: { isLoggedIn: true, ok: true, message: "Deleted." }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: "Failed." }, status: 500
    end
  end

  private
    # strong parameters
    def update_word_params
      params.require(:word).permit(:id, :name)
    end

    def create_word_list_params
      params.require(:words)
    end

    # set
    def set_game
      @game ||= Game.find_by_id params[:game_id]
      render_game_not_found if @game.blank?
      render_game_suspended if @game.is_suspended || @game.owner.is_suspended
      render_game_not_published if !@game.is_published && @game.owner != current_api_v1_user
    end

    def set_word
      @word ||= Word.find_by_id params[:id]
      render_word_not_found if @word.blank?
      render_game_suspended if @word.game.is_suspended || @word.game.owner.is_suspended
      render_game_not_published if !@word.game.is_published && @word.game.owner != current_api_v1_user
    end

    # check
    def authenticate_owner
      render_word_not_found if @word.blank?
      render_user_not_logged_in if !api_v1_user_signed_in?
      render_game_not_owner if @word.game.owner != current_api_v1_user
    end
end
