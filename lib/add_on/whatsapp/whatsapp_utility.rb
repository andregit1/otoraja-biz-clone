module Whatsapp
  SEND_TEXT_ENDPOINT = "sendText"
  class WhatsappUtility
    class << self
      DAMCORP_API = 'https://waba.damcorp.id/whatsapp/'
      SEND_HSM_ENDPOINT = 'sendHsm/'
      REQUEST_HEADER = {'Content-Type': 'application/json'}
      ERROR_RESPONSE = {'data' => [{'msgId' => nil, 'status' => SendMessage.wa_send_statuses.key(7)}]}

      def send_hsm(template, data)
        sanitized_data = data.merge!("to" => data["to"].map{|x| sanitize_phone_number(x)})
        return if sanitized_data["to"].blank?

        do_http_request(build_url(SEND_HSM_ENDPOINT, template), sanitized_data)
      end

      def send_text(data)
        do_http_request(build_url(SEND_TEXT_ENDPOINT), data)
      end
      
      def send_wa_notification(object)
        phone_number = sanitize_phone_number(object[:to])
        unless object[:template].nil? || phone_number.nil?
          send_message = SendMessage.create(
            from: object[:from], 
            to: sanitize_phone_number(object[:to]), 
            body: object[:template].template_name, 
            send_type: :wa, 
            send_purpose: object[:send_purpose], 
            send_datetime: DateTime.now,
            resend_attempts: 0,
            parameters: object[:params].to_json
          )
          data = {
            'to' => [send_message.to],
            'param'=> object[:params]
          }
          response = send_hsm(object[:template].template_name, data)
          #if the template is not found or has not been binded, response will not contain the data property
          #this situation can and did occur when whats app business account phone number was changed
          unless response["data"].nil?
            data = response["data"].first unless response["data"].nil?
            send_message.update(sent_at: DateTime.now, message_id: data["msgId"], send_status: data["status"])
          else
            Rails.logger.warn("Whats App template #{object[:template]} may be misspelled or has not been binded to What App phone number")
            send_message.update(sent_at: DateTime.now, send_status: "bad request")
          end
          return send_message
        end
      end

    private 
      def build_url(endpint, *optional)
        URI.join(DAMCORP_API, endpint, *optional)
      end

      def sanitize_phone_number(phone)
        return phone if phone.blank? || phone.include?("+62")

        if phone.first(2) == "08"
          phone.sub(/08/, "+628")
        elsif phone.first(2) == "62"
          phone.sub(/62/, "+62")
        else
          phone.prepend("+62")
        end
      end

      # Create the HTTP objects
      def do_http_request(uri, data)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        # http.open_timeout = 5   # unit is seconds, default is 60
        # http.read_timeout = 65  # unit is seconds, default is 60
        request = Net::HTTP::Post.new(uri.request_uri, REQUEST_HEADER)
        # set DamCorp Api Token
        data['token'] = ENV['DAMCORP_API_TOKEN']
        request.body = data.to_json
        begin
          Rails.logger.debug("DamCorp API start request #{uri.request_uri} #{request.inspect}")
          http.request(request) do |res|
            Rails.logger.debug("DamCorp API response #{uri.request_uri} #{res.inspect}")
            
            if res.kind_of? Net::HTTPSuccess
              res.read_body do |s|
                @response = JSON.parse(s)
              end
            else
              @response = ERROR_RESPONSE
              Rails.logger.warn('DamCorp API returned and error.')
            end
          end
        rescue => e
          @response = ERROR_RESPONSE
          Rails.logger.error("DamCorp API error: #{e.message}")
        end
        return @response
      end
    end
  end
end
