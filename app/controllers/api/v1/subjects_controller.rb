class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_api_v1_user!, except: []
  before_action :authenticate_owner, except: [:create]

  # Authenticated user
  def create
    return render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401 unless api_v1_user_signed_in?
    game = Game.find_by_id(game_params[:game_id])
    return render json: { isLoggedIn: false, ok: false, message: "You are not the owner of the game." }, status: 401 unless game.present? && current_api_v1_user == game.owner
    invalid_words = []
    words_params.each do |word|
      subject = game.subjects.build(word: word.upcase)
      invalid_words << word unless subject.save
    end
    if invalid_words.length == 0
      render json: { isLoggedIn: true, ok: true, message: "All of the words have been created successfully." }, status: 201
    elsif words_params.length > invalid_words.length
      render json: { isLoggedIn: true, ok: true, message: "The words have been created successfully, but some of them were failed.", data: invalid_words }, status: 207
    else
      render json: { isLoggedIn: true, ok: false, message: "The words are failed." }, status: 500
    end
  end

  # Authenticated owner
  def update
    if @subject.update(subject_params.to_h.transform_values{|v| v.is_a?(String) ? v.upcase : v})
      render json: { isLoggedIn: true, ok: true, message: "Updated.", data: @subject }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: @subject.errors.messages, data: @subject }, status: 500
    end
  end

  def destroy
    if @subject.destroy
      render json: { isLoggedIn: true, ok: true, message: "Deleted.", data: @subject }, status: 200
    else
      render json: { isLoggedIn: true, ok: false, message: "Failed." }, status: 500
    end
  end

  private
    def subject_params
      params.require(:subject).permit(:id, :word)
    end

    def words_params
      params.require(:words)
    end

    def game_params
      params.require(:game).permit(:game_id)
    end

    def authenticate_owner
      return render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401 unless api_v1_user_signed_in?
      @subject = Subject.find_by_id(params[:id])
      return render json: { isLoggedIn: false, ok: false, message: "You are not the owner of the game." }, status: 401 unless @subject.present? && @subject.game.owner == current_api_v1_user
    end
end
