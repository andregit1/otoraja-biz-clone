module Email
  class EmailUtility
    class << self
      def send_email_notification(object)
        if object[:to].present?
          create_send_message(object)
        end

        ##This is only for right now, because the cc cant be sent since 29/10/2021
        if object[:cc].present?
          if object[:cc].is_a?(Array)
            object[:cc].each do |cc|
              object.update(to: cc)
              create_send_message(object)
            end
          elsif object[:cc].is_a?(String)
            object.update(to: cc)
            create_send_message(object)
          end
        end
      end

      def send_email_on_development(receiver, subject, body)
        begin
          ActionMailer::Base.mail(
            from: "noreply@otoraja.com",
            to: receiver,
            subject: subject,
            body: body,
          ).deliver
    
        rescue => e
          logger.error(e)
          status = nil
        end
      end

      private
        def create_send_message(object)
          SendMessage.create(
            to: object[:to],
            from: object[:from],
            subject: object[:subject],
            body: object[:body],
            send_type: :email,
            send_purpose: object[:send_purpose],
            send_datetime: object[:send_datetime]
          )
        end
    end
  end
end