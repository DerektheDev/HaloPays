module HaloPays
  module Token

    class << self
      def create_for_ach opts
        token_payload = {
          test: opts[:test],
          pay_type: 'ACH',
          ach_account: opts[:account_number]
        }.to_json

        response = HaloPays.token_connection.post '/tokens/', token_payload
        response.body
      end

      def create_for_card opts
        token_payload = {
          test: opts[:test],
          pay_type: 'CARD',
          card_number: opts[:card_number]
        }.to_json

        response = HaloPays.token_connection.post '/tokens/', token_payload
        response.body
      end

      def view token
        response = HaloPays.connection.get "/tokens/#{token}"
        unless response.body.has_key? 'errors'
          response.body
        else
          nil
        end
      end

      def view_all
        response = HaloPays.connection.get '/tokens/'
        JSON.parse response.body
      end

      def activate opts

        case opts[:payment][:pay_type]
        when 'CARD'
          status, amount = 'AUTHORIZED', 0
        when 'ACH'
          status, amount = 'CAPTURED', 0 # TODO: HP will fix this to accept 0 on both
        end

        activate_payload = {
          test:            opts[:test],
          trans_type:      'DONATION',
          status:          status,
          order_id:        'some-order-id',
          amount:          amount,
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents Account Activation ($0.00)',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }.to_json

        response = HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", activate_payload

        response.body
      end

      def delete token

      end

    end
  end
end
