module Payment  
  class PaymentUtility
    class << self
    
      def getPaymentMethod(limit, page=0)
        url = build_url('type')
        params = { limit: limit, page: page }
        Request::RequestUtility.get(url, params)    
      end

      def getPaymentTypeDetail(id)
        url = build_url("type/#{id}")
        Request::RequestUtility.get(url)  
      end

      def get_transaction_status(id)
        url = build_url("transaction/status/#{id}")
        Request::RequestUtility.get(url) 
      end

      def create_payment(data)
        url = build_url("transaction")
        Request::RequestUtility.post(url, data)
      end

      def cancel_payment(data)
        url = build_url("transaction/cancel")
        Request::RequestUtility.post(url, data)
      end

      private 

      def build_url(endpoint)
        version_state = PaymentGateway.find_by(is_active: 1)&.version
        url = URI.join(ENV['PAYMENT_URL'], version_state, endpoint)
        puts "PAYMENT HIT :  #{url}" if Rails.env.staging? || Rails.env.development?
        return url
      end
    end
  end
end
