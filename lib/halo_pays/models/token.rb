module HaloPays
  module Token
  
    class << self
      def create_for_ach account_number
        response = HaloPays.connection.post '/tokens/', {
          test: Rails.env.development?,
          pay_type: 'ACH',
          ach_account: account_number
        }
        JSON.parse response.body
      end

      def create_for_card card_number
        response = HaloPays.connection.post '/tokens/', {
          test: Rails.env.development?,
          pay_type: 'CARD',
          card_number: card_number
        }
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
        response = HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", {
          test:            Rails.env.development?,
          trans_type:      'DONATION',
          amount:          000,
          # order_id
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents Account Activation ($0.00)',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }
        JSON.parse response.body
      end

      def delete token

      end

    end
  end
end
