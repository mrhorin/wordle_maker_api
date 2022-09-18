Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.credentials[:twitter][:api_key], Rails.application.credentials[:twitter][:api_secret], callback_url: "#{Rails.configuration.app[:URL][:API][:PROTOCOL]}://#{Rails.configuration.app[:URL][:API][:DOMAIN]}/omniauth/twitter/callback"
end