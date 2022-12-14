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
      resources :games, only: [:index, :show, :update, :destroy, :create] do
        collection do
          get 'play/:id', to: 'games#play'
          get 'current-user-index', to: 'games#current_user_index'
          get 'pv-ranking', to: 'games#pv_ranking'
        end

        # /games/:game_id/words
        resources :words, only: [] do
          collection do
            get '/', to: 'words#index'
            get 'today', to: 'words#today'
            get 'edit', to: 'words#edit'
          end
        end
      end

      # /words
      resources :words, only: [:update, :destroy, :create]

    end
  end
end
