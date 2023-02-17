class SendCustomerReminder
  def self.execute
    puts 'Execute send_customer_reminder.rb'
    send_customer_reminder
  end

  def self.send_customer_reminder
    remind_checkins = Checkin.need_customer_remind
    scheduled_to_send_count = remind_checkins.size
    sent_count = 0

    shop_ids = remind_checkins.pluck(:shop_id).uniq
    shop_ids.each do |shop_id|
      begin
        shop = Shop.find(shop_id)
        
        # 対応する店舗に対して送信する
        checkins = remind_checkins.select {|checkin| checkin.shop_id == shop_id}
        checkins.each do |checkin|
          send_wa_notif(checkin)
          check_sms = send_sms_notif(checkin)
          
          if check_sms
            sent_count += 1
          end
        end
      rescue => exception
        puts "Error: #{exception}, File: send_reminder.rb"
      end
    end

    # 結果表示
    if scheduled_to_send_count.zero?
      puts 'Result: There was no customer reminder.'
    else
      puts "Result: Sent #{sent_count}/#{scheduled_to_send_count} customer reminder"
      unless scheduled_to_send_count === sent_count
        puts "Could not send #{scheduled_to_send_count - sent_count} customer reminder"
      end
    end
  end

  def self.send_wa_notif(checkin)
    shop = Shop.find(checkin.shop_id)
    # Retrieve Attribute to Use Whatsapp Utilities
    object = {
      from: shop.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_reminder_service_new_v1]),
      params: [shop.name],
      to: checkin.customer.wa_tel,
      send_purpose: SendMessage.send_purposes["customer_remind"]
    }
    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def self.send_sms_notif(checkin)
    # SMS送信
    client = Aws::AwsUtility.SNS_client
    shop = Shop.find(checkin.shop_id)
    body = I18n.t('message.body.sms_customer_reminder', shop: shop.name)
    
    send_message = SendMessage.new(
      to: checkin.customer.tel, 
      body: body, 
      send_type: :sms, 
      send_purpose: :customer_remind, 
      send_datetime: DateTime.now
    )

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

    send_message.sent_at = DateTime.now
    send_message.message_id = resp.message_id
    if send_message.save
      CustomerReminderLog.create(send_message: send_message, customer: checkin.customer, checkin_id: checkin.last_checkout_id)
      return true
    else
      return false
    end
  end

end

SendCustomerReminder.execute
