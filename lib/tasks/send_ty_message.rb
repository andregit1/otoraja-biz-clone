class SendTyMessage
  class << self
    include Rails.application.routes.url_helpers
  end

  def self.execute
    # 送信メッセージ登録
    register_ty_message

    # サンキューSMS送信
    send_ty_sms
  end

  def self.register_ty_message
    checkins = Checkin.need_register_ty_message
    puts "#{checkins.length} - checkins"
    unless checkins.empty?
      puts "Create #{checkins.length} ty message"
      rescue_count = 0
      checkins.each do |checkin|
        begin
          create_send_message(checkin)
        rescue => exception
          rescue_count += 1
          puts "#{exception} file: send_ty_message.rb in: register_ty_message"
          puts exception.backtrace.join("\n")
        end
      end

      puts "Created #{checkins.length - rescue_count} ty message"
      unless rescue_count === 0
        puts "Could not create #{rescue_count} ty message"
      end
    end
  end

  def self.create_send_message(checkin)
    shop_config = ShopConfig.find_by(shop: checkin.shop)
    expired_at = DateTime.now + shop_config.questionnaire_expiration_days
    token = Token.create_questionnaire_token(checkin, expired_at)

    short_url = generate_short_url(token)
    body = "Terimakasih atas kedatangannya. Saran anda berguna bagi kami untuk perbaikan kepuasan pelanggan #{checkin.shop.name}. #{short_url}"
    now = DateTime.now
    confing_send_time = shop_config.message_send_time.to_datetime
    send_datetime = DateTime.new(now.year, now.month, now.day, confing_send_time.hour, confing_send_time.min)
    puts send_datetime
    if send_datetime < now
      # 送信日時が過ぎていた場合翌日に設定
      send_datetime += 1
    end
    send_message = SendMessage.create(to: checkin.customer.tel, body: body, send_type: :sms, send_purpose: :ty, send_datetime: send_datetime)
    answer_choice_group = AnswerChoiceGroup.find_by(name: 'Default')
    Questionnaire.create(checkin: checkin, send_message: send_message, answer_choice_group: answer_choice_group)
  end

  def self.generate_short_url(token)
    url = "https://#{ENV['DOMAIN_NAME']}#{questionnaire_path('uuid')}".sub(/uuid/, token.uuid)
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def self.send_ty_sms
    sms_send_messages = SendMessage.ty.sms.where(sent_at: nil).where('send_datetime <= ?', DateTime.now)

    unless sms_send_messages.empty?
      puts "Send #{sms_send_messages.length} SMS"
      client = Aws::AwsUtility.SNS_client

      sent_count = 0
      sms_send_messages.each do |send_message|
        begin
          resp = client.publish({
            phone_number: send_message.to,
            message: send_message.body,
            message_attributes: {
              'AWS.SNS.SMS.SMSType' => {
                data_type: 'String',
                string_value: 'Transactional'
              }
            }
          })
          send_message.update(sent_at: DateTime.now, message_id: resp.message_id)
          sent_count += 1
        rescue => exception
          puts "#{exception} file: send_ty_message.rb in: send_ty_sms"
          puts exception.backtrace.join("\n")
        end
      end
      puts "Sent #{sent_count} SMS"
      unless sms_send_messages.length === sent_count
        puts "Could not send #{sms_send_messages.length - sent_count} SMS"
      end
    end
  end
end

SendTyMessage.execute
