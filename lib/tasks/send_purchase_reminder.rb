class SendPurchaseReminder
  def self.execute
    puts 'Execute send_reminder.rb'
    send_purchase_reminder
  end

  def self.send_purchase_reminder
    scheduled_to_send_count = 0
    sent_count = 0
    reminds = []

    # リマインド未送信、DM許可、電話番号有り、ナンバープレート有り
    PurchaseHistory.joins(:customer).where(reminded: false, customers: {send_dm: true}).where.not(customers: {tel: nil}).each do |purchase_history|
      begin
        shop_product = purchase_history.shop_product
        product_category = shop_product.product_category

        if purchase_history.last_purchase_date + shop_product.remind_interval_day.days <= Date.today
          scheduled_to_send_count += 1
          ## Send WA Notif
          send_message = send_wa_notif(purchase_history,  product_category.name)
          ## send sms notif
          check_sms = send_sms_notif(purchase_history, product_category.name)
          if check_sms 
            purchase_history.update(reminded: true)
            sent_count += 1
            ProductReminderLog.create(send_message: send_message, maintenance_log_detail: purchase_history.maintenance_log_detail)
          end
        end
      rescue => exception
        puts "Error: #{exception}, File: send_reminder.rb"
      end
    end

    # 結果表示
    if scheduled_to_send_count.zero?
      puts 'Result: There was no reminder.'
    else
      puts "Result: Sent #{sent_count}/#{scheduled_to_send_count} Reminder"
      unless scheduled_to_send_count === sent_count
        puts "Could not send #{scheduled_to_send_count - sent_count} Reminder"
      end
    end
  end

  def self.send_wa_notif(purchase_history, category_name)
    shop = Shop.find(purchase_history.shop_product.shop_id)

    # Retrieve Attribute to Use Whatsapp Utilities
    object = {
      from: shop.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_reminder_purchase_new_v1]),
      params: [category_name, shop.name],
      to: purchase_history.customer.wa_tel,
      send_purpose: SendMessage.send_purposes["customer_remind"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def self.send_sms_notif(purchase_history, category_name)
    # SMS送信
    client = Aws::AwsUtility.SNS_client
    shop = Shop.find(purchase_history.shop_product.shop_id)
    body = I18n.t('message.body.sms_purchase_reminder', category_name: category_name, shop: shop.name)
    send_message = SendMessage.new(to: purchase_history.customer.tel, body: body, send_type: :sms, send_purpose: SendMessage.send_purposes["customer_remind"], send_datetime: DateTime.now)
  
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
      return true
    else
      return false
    end
  end

end

SendPurchaseReminder.execute
