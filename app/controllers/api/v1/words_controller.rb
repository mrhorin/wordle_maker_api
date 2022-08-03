class Api::V1::WordsController < ApplicationController
  include Pagination
  before_action :authenticate_api_v1_user!, except: [:index, :today]
  before_action :authenticate_owner, only: [:update, :destroy]
  before_action :set_game, only: [:index, :today, :create, :edit]

  def index
    word_list = Rails.cache.fetch("words_index#{@game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){
      return nil unless @game.word_list.present?
      @game.word_list
    }
    if word_list.present?
      render json: { ok: true, isSuspended: false, data: word_list }, status: 200
    else
      render json: { ok: false, isSuspended: false, message: "Game ID #{params[:id]} has no words yet." }, status: 404
    end
  end

  def today
    today = Rails.cache.fetch("words_today#{@game.id}", skip_nil: true, expires_in: Time.now.at_end_of_day - Time.now){
      question = @game.questions.find_or_create_today
      return nil unless question.word.present? && question.no.present?
      question
    }
    if today.present? && today.word.present? && today.no.present?
      render json: { ok: true, data: { word: today.word, questionNo: today.no} }, status: 200
    else
      render json: { ok: false, message: "Game ID #{params[:game_id]} hasn't had any words yet." }, status: 404
    end
  end

  # Authenticated user
  def create
    return render json: { isLoggedIn: false, ok: false, message: "You are not the owner of the game." }, status: 401 unless @game.present? && current_api_v1_user == @game.owner
    invalid_words = []
    word_list_params.each do |item|
      word = @game.words.build(name: item.upcase)
      invalid_words << word unless word.save
    end
    if invalid_words.length == 0
      render json: { isLoggedIn: true, ok: true, message: "All of the words have been created successfully." }, status: 201
    elsif word_list_params.length > invalid_words.length
      render json: { isLoggedIn: true, ok: true, message: "The words have been created successfully, but some of them were failed.", data: invalid_words }, status: 207
    else
      render json: { isLoggedIn: true, ok: false, message: "The words are failed." }, status: 500
    end
  end

  # Authenticated owner
  def edit
    return render json: { ok: false, isLoggedIn: false, message: "You're not the owner of the game." }, status: 401 unless @game.owner == current_api_v1_user
    page = params[:page]
    per = params[:per].present? ? params[:per] : 50
    words_paginated = @game.words.select(:id, :name).order(id: :desc).page(page).per(per)
    pagination = pagination(words_paginated)
    render json: { ok: true, isLoggedIn: true, isSuspended: false, data: {words: words_paginated, pagination: pagination} }, status: 200
  end

  def update
    if @word.update(word_params.to_h.transform_values{|v| v.is_a?(String) ? v.upcase : v})
      render json: { isLoggedIn: true, ok: true, message: "Updated.", data: @word }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: @word.errors.messages, data: @word }, status: 500
    end
  end

  def destroy
    if @word.destroy
      render json: { isLoggedIn: true, ok: true, message: "Deleted.", data: @word }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: "Failed." }, status: 500
    end
  end

  private
    def word_params
      params.require(:word).permit(:id, :name)
    end

    def word_list_params
      params.require(:words)
    end

    def game_params
      params.require(:game).permit(:game_id)
    end

    def set_game
      @game = Game.find_by_id(params[:game_id])
      render json: { ok: false, isSuspended: false, message: "Game ID #{params[:id]} is not found." }, status: 404 unless @game.present?
    end

    def authenticate_owner
      return render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401 unless api_v1_user_signed_in?
      @word = Word.find_by_id(params[:id])
      return render json: { isLoggedIn: false, ok: false, message: "You are not the owner of the game." }, status: 401 unless @word.present? && @word.game.owner == current_api_v1_user
    end
end
