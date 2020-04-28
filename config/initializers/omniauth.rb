Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, twitter_consumer_key, twitter_consumer_secret
end