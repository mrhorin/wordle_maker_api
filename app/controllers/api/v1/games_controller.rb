class Api::V1::GamesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :langs]

  def langs
    langs = Utils::Language.langs.map{|k,v| { name: v[:name], code: k.to_s}}
    render json: { data: langs }, status: 200
  end

end
