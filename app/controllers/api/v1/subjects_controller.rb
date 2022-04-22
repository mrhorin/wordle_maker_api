class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_api_v1_user!, except: []

  # Authenticated
  def create
    game = Game.find_by_id(game_params[:game_id])
    if api_v1_user_signed_in? && current_api_v1_user.id == game.user_id
      invalid_words = []
      words_params.each do |word|
        subject = Subject.create_or_find_by(game_id: game_params[:game_id], word: word.upcase)
        invalid_words << word unless subject.save
      end
      if invalid_words.length == 0
        render json: { isLoggedIn: true, ok: true, message: "All of the words have been created successfully." }, status: 201
      elsif words_params.length > invalid_words.length
        render json: { isLoggedIn: true, ok: true, message: "The words have been created successfully, but some of them were failed.", data: invalid_words }, status: 207
      else
        render json: { isLoggedIn: true, ok: false, message: "The words are failed." }, status: 500
      end
    else
      render json: { isLoggedIn: false, ok: false, message: "You are not logged in." }, status: 401
    end
  end

  private
    def words_params
      params.require(:words)
    end

    def game_params
      params.require(:game).permit(:game_id)
    end
end
