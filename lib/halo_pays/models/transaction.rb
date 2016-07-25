module HaloPays
  module Transaction
    class << self

      def post opts
        status = case opts[:payment][:pay_type]
        when 'CARD' then 'AUTHORIZED'
        when 'ACH' then 'CAPTURED'
        end

        amount = opts[:test] ? 0 : opts[:payment][:amount]

        payment_payload = {
          test:            opts[:test],
          trans_type:      'DONATION',
          status:          status,
          order_id:        opts[:order_id],
          amount:          opts[:amount].to_i,
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
