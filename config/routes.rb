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
        post 'create', to: 'games#create'
        get 'list_current_games', to: 'games#list_current_games'
        get 'supported_langs', to: 'games#supported_langs'
        get ':id', to: 'games#show'
        put ':id', to: 'games#update'
        delete ':id', to: 'games#destroy'
        get ':id/subjects', to: 'games#subjects'
      end

      # SubjectsController
      scope :subjects do
        post 'create', to: 'subjects#create'
        delete ':id', to: 'subjects#destroy'
      end

    end
  end

end
