require 'hashie'
require 'faraday'
require 'faraday_middleware'

module HaloPays
  class << self
    def connection
      url = Rails.application.secrets.halopays['api_url']
      conn = Faraday.new(url: url) do |c|
        # TODO: Replace below with config stuff
        # c.headers['Authorization']# = "#{Rails.application.secrets.halopays['api']['private_key']}:x"
        c.basic_auth Rails.application.secrets.halopays['partner_key']['private'], 'x'
        c.headers['Accept'] = 'application/com.halopays.api-v1+json'
        c.headers['Content-Type'] = 'application/com.halopays.api-v1+json'
        # c.request  :url_encoded
        # c.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
        c.use FaradayMiddleware::Mashify
        c.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
        c.adapter  Faraday.default_adapter        # make requests with Net::HTTP
      end
    end
  end
end
