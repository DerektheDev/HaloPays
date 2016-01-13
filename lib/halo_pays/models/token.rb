module HaloPays
  module Token
  
    class << self
      def create_for_ach account_number
        token_payload = {
          test: Rails.env.development?,
          pay_type: 'ACH',
          ach_account: account_number
        }.to_json

        response = HaloPays.token_connection.post '/tokens/', token_payload

        response.body
      end

      def create_for_card card_number
        response = HaloPays.connection.post '/tokens/', {
          test: Rails.env.development?,
          pay_type: 'CARD',
          card_number: card_number
        }.to_json
        JSON.parse response.body
      end

      def view token
        response = HaloPays.connection.get "/tokens/#{token}"
        JSON.parse response.body
      end

      def view_all
        response = HaloPays.connection.get '/tokens/'
        JSON.parse response.body
      end

      def activate opts

        activate_payload = {
          test:            true,
          trans_type:      'DONATION',
          status:          'CAPTURED',
          order_id:        'some-order-id',
          amount:          000,
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents Account Activation ($0.00)',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }.to_json

        binding.pry

        # response = HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", activate_payload
        # response.body
      end

      def delete token

      end

    end
  end
end
