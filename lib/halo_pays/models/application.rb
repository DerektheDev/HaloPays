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

      def submit application_object
        # TODO: Finish this! Error with how I'm passing it...
        response = HaloPays.connection.post '/applications/', URI.encode_www_form(application_object)

        JSON.parse response.body
      end
    end
  end
end
