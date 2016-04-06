module HaloPays
  module Transaction
    class << self

      def post opts
        case opts[:payment][:pay_type]
        when 'CARD'
          status, amount = 'AUTHORIZED', 0
        when 'ACH'
          status, amount = 'CAPTURED', 100 # TODO: HP will fix this to accept 0 on both
        end

        payment_payload = {
          test:            Rails.env.development?,
          trans_type:      'DONATION',
          status:          status,
          order_id:        SecureRandom.hex,
          amount:          amount,
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }.to_json

        response = HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", payment_payload
        response.body
      end
    end

  end
end
