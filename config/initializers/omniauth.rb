Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.credentials[:twitter][:api_key], Rails.application.credentials[:twitter][:api_secret], callback_url: "http://localhost:3000/omniauth/twitter/callback"
end