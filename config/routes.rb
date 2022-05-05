Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Authentication
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks',
        sessions: 'api/v1/auth/sessions',
        registrations: 'api/v1/auth/registrations'
      }

      # UsersController
      scope :users do
        get 'current', to: 'users#current'
      end

      # GamesController
      scope :games do
        get 'list_current_games', to: 'games#list_current_games'
        get 'supported_langs', to: 'games#supported_langs'
        get ':id/word_list', to: 'games#word_list'
        get ':id/words', to: 'games#words'
        get ':id', to: 'games#show'
        put ':id', to: 'games#update'
        delete ':id', to: 'games#destroy'
        post 'create', to: 'games#create'
      end

      # WordsController
      scope :words do
        get 'today/:game_id', to: 'words#today'
        put ':id', to: 'words#update'
        delete ':id', to: 'words#destroy'
        post 'create', to: 'words#create'
      end
    end
  end

end
