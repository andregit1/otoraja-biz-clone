module Request
  class RequestUtility    
    class << self
      REQUEST_HEADER = {'Content-Type': 'application/json'}

      def get(url, params = {})
        uri = URI(url)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth ENV['PAYMENT_USERNAME'], ENV['PAYMENT_PASSWORD']

        begin
          http.request(request) do |response|
            if response.kind_of? Net::HTTPSuccess
              @result = response_bind(response)
            else
              @result = response_bind(response)
              Rails.logger.warn('Payment Gateway API returned and error.')
            end
          end
        rescue => e
          Rails.logger.error("Payment Gateway API error: #{e.message}")
        end
        return @result
      end
      
      def post(url, data)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Post.new(uri.request_uri, REQUEST_HEADER)
        request.basic_auth ENV['PAYMENT_USERNAME'], ENV['PAYMENT_PASSWORD']
        request.body = data.to_json
        @result = {}
        
        begin
          http.request(request) do |response|
            if response.kind_of? Net::HTTPSuccess
              @result = response_bind(response)
            else
              @result = response_bind(response)
              Rails.logger.warn('Payment Gateway API returned and error.')
            end
          end
        rescue => e
          Rails.logger.error(" API error: #{e.message}")
        end
        return @result
      end
      
      private
      def response_bind(response)
        result = {}
        response.read_body do |s|
          result = JSON.parse(s)
        end
        result['code'] = response.code
        return result
      end

    end
  end

end