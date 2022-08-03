Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Authentication
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks',
        sessions: 'api/v1/auth/sessions',
        registrations: 'api/v1/auth/registrations'
      }

      # /users
      scope :users do
        get 'current', to: 'users#current'
      end

      # /games
      resources :games, only: [:show, :update, :destroy, :create] do
        collection do
          get 'list_current_games', to: 'games#list_current_games'
          get 'supported_langs', to: 'games#supported_langs'
        end

        member do
          get 'word_list', to: 'games#word_list'
          get 'words', to: 'games#words'
        end
      end

      # /words
      resources :words, only: [:update, :destroy, :create] do
        collection do
          get 'today/:game_id', to: 'words#today'
        end
      end
    end
  end
end
