# gem dependency
require 'hashie'
require 'faraday'
require 'faraday_middleware'

# config
require 'halo_pays/version'

# models
require 'halo_pays/models/application'
require 'halo_pays/models/merchant'
require 'halo_pays/models/token'
require 'halo_pays/models/transaction'

module HaloPays
  class << self
    # TODO: Extract this to a HaloPays::Connection config file
    def connection
      conn = Faraday.new(url: 'https://api.halopays.com') do |config|
        # TODO: Replace below with config stuff
        # config.headers['Authorization']# = "#{Rails.application.secrets.halopays['api']['private_key']}:x"
        config.basic_auth Rails.application.secrets.halopays['partner_key']['private'], 'x'
        config.headers['Accept'] = 'application/com.halopays.api-v1+json'
        config.headers['Content-Type'] = 'application/com.halopays.api-v1+json'
        # config.request  :url_encoded
        # config.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
        config.use FaradayMiddleware::Mashify
        # config.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
        # config.request :json
        config.response :json
        config.adapter  Faraday.default_adapter        # make requests with Net::HTTP
      end
    end

    def token_connection
      conn = Faraday.new(url: 'https://api.halopays.com') do |config|
        config.basic_auth Rails.application.secrets.halopays['partner_key']['public'], 'x'
        config.headers['Accept'] = 'application/com.halopays.api-v1+json'
        config.headers['Content-Type'] = 'application/com.halopays.api-v1+json'
        config.use FaradayMiddleware::Mashify
        # config.use Faraday::Response::RaiseError
        config.adapter Faraday.default_adapter
      end
    end

# =================

    def round_up_connection
      conn = Faraday.new(url: 'https://api.halopays.com') do |config|
        config.basic_auth Rails.application.secrets.halopays['round_up_partner_key']['private'], 'x'
        config.headers['Accept'] = 'application/com.halopays.api-v1+json'
        config.headers['Content-Type'] = 'application/com.halopays.api-v1+json'
        config.use FaradayMiddleware::Mashify
        config.response :json
        config.adapter  Faraday.default_adapter        # make requests with Net::HTTP
      end
    end

    def round_up_token_connection
      conn = Faraday.new(url: 'https://api.halopays.com') do |config|
        config.basic_auth Rails.application.secrets.halopays['round_up_partner_key']['public'], 'x'
        config.headers['Accept'] = 'application/com.halopays.api-v1+json'
        config.headers['Content-Type'] = 'application/com.halopays.api-v1+json'
        config.use FaradayMiddleware::Mashify
        config.adapter Faraday.default_adapter
      end
    end

  end
end
