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
          order_id:        opts[:order_id],
          amount:          amount,
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }

        payment_payload.merge!(opts[:recurring]) if opts[:recurring].present?

        payment_payload = payment_payload.to_json

        response = HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", payment_payload
        response.body
      end
    end

    def cancel_recurring merchant_id, order_id
      # should return 204
      response = HaloPays.connection.delete "/merchants/#{merchant_id}/recurring/#{order_id}", payment_payload
      response.body
    end

  end
end
