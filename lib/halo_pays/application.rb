module HaloPays
  module Application

    class << self
      def view_all
        response = HaloPays.connection.get '/applications/'
        JSON.parse response.body
      end

      def view application_id
        response = HaloPays.connection.get "/applications/#{application_id}"
        JSON.parse response.body
      end

      def submit legal_entity_json, merchant_json
        response = HaloPays.connection.post "/applications/", {
          agree_tc: true,
          agree_ip: '127.0.0.1',
          test: Rails.env.development?,
          legal_entity: legal_entity_json,
          merchant: merchant_json
        }
        JSON.parse response.body
      end
    end
  end
end
