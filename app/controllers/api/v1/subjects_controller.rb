class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_api_v1_user!, except: []

  # Authenticated
  def create
    game = Game.find(game_params[:game_id])
    if api_v1_user_signed_in? && current_api_v1_user.id == game.user_id
      invalid_words = []
      words_params.each do |word|
        subject = Subject.create_or_find_by(game_id: game_params[:game_id], word: word)
        invalid_words << word unless subject.save
      end
      if invalid_words.length == 0
        render json: { isLoggedIn: true, ok: true, message: "All of words are Created." }, status: 201
      else
        render json: { isLoggedIn: true, ok: false, message: "Some of the parameters are incorrect.", data: invalid_words }, status: 500
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
