class WhatsAppResend
  def self.execute
    begin
      puts "executing Whatsapp resend"
      #template that accepts one dynamic parameter. This should contain the entier body of the original message
      template = "otoraja_resend_message"
      resend_interval = 1
      max_resend_attempts = 3
      #get data
      #has not reached 'max_resend_attempts'
      #sent_at is 'resend_interval' old or older (in hours)
      #status is either 'invalid'(5), 'failed'(3) or 'bad_request'(6) or 'unsent'(7)
      #send_type is 'wa'
      resend_messages = SendMessage.where("sent_at <= ? AND resend_attempts < ? AND send_status IN(?,?,?,?) AND send_type = ?", DateTime.now - resend_interval.hours, max_resend_attempts, SendMessage.wa_send_statuses.key(5), SendMessage.wa_send_statuses.key(3), SendMessage.wa_send_statuses.key(6), SendMessage.wa_send_statuses.key(7), SendMessage.send_types[:wa])
      resend_messages.each do | message |
        data = {
          "to"=>[message.to]
        }
        if message.body == Whatsapp::SEND_TEXT_ENDPOINT
          params =  message.parameters
          data["messsage"] = params
          response = Whatsapp::WhatsappUtility.send_text(data)
        else
          params =  JSON.parse(message.parameters)
          data["param"] = params
          response = Whatsapp::WhatsappUtility.send_hsm(message.body, data)
        end
        
        resend_attempts = message.resend_attempts + 1
        response = response["data"].first
        message.sent_at = DateTime.now
        message.resend_attempts = resend_attempts
        message.send_status = response["status"]
        message.message_id = response["msgId"]
        message.save!
      end
    rescue => e
      puts "error WhatsAppResend #{e.message}", e.backtrace
    end
    puts "finished Whatsapp resend"
  end
end

WhatsAppResend.execute