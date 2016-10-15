module HaloPays
  module Transaction
    class << self

      def post opts
        amount = opts[:test] ? 0 : opts[:payment][:amount]

        payment_payload = {
          test:            opts[:test],
          trans_type:      'DONATION',
          status:          'CAPTURED',
          order_id:        opts[:order_id],
          amount:          opts[:amount],
          order_source:    'ONLINE',
          remote_ip:       opts[:remote_ip],
          description:     'Good Cents',
          email_receipt:   false,
          payment:         opts[:payment],
          billing_contact: opts[:billing_info]
        }

        payment_payload.merge!(opts[:recurring]) if opts[:recurring].present?
        payment_payload = payment_payload.to_json

        response = if opts[:round_up].present? && opts[:round_up] == true
          HaloPays.round_up_connection.post "/merchants/#{opts[:merchant_id]}/transactions/", payment_payload
        else
          HaloPays.connection.post "/merchants/#{opts[:merchant_id]}/transactions/", payment_payload
        end
        response.body
      end


      def cancel_recurring merchant_id, order_id
        # should return 204
        response = HaloPays.connection.delete "/merchants/#{merchant_id}/recurring/#{order_id}", payment_payload
        response.body
      end
    end

  end
end
