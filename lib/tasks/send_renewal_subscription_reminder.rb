class SendRenewalSubscriptionReminder
  def self.execute
    puts "executing subscription renewal reminder"
    today = Date.today.in_time_zone('Jakarta')
    @shop_expired = Shop.joins(%|LEFT JOIN subscriptions ON shops.active_plan = subscriptions.id|)
                    .where('shops.subscriber_type = 2')
                    .where('subscriptions.status = 4')
                    .where('DATE(expiration_date) = ?', today.to_date + 5.days)
    unless @shop_expired.empty?
      begin
        @shop_expired.each do | shop |
          Rails.logger.info("Bengkel:#{shop.name} email:#{shop.shop_group.owner_email}")
          send_wa(shop)
          send_email(shop)
        end
      rescue => e
        puts e.message
        Rails.logger.error(e.message)
      end
    end
  end

  def self.send_email(shop)
    subject = I18n.t('subscription.email.subject.renewal_notification')
    body = I18n.t('subscription.email.body.bengkel_expired', 
      status: shop.active_plan ? "": "Demo ", 
      shop_name: shop.name, 
      date: shop.expiration_date.in_time_zone('Jakarta').strftime('%d/%m/%Y'), 
      link: subscription_link
    )
    
    if shop.shop_group.owner_email.present?
      create_email(shop.shop_group.owner_email, subject, body)
    end
    
    if shop.shop_group.owner_email.blank?
      create_email(ENV['PRODUCT_EMAIL'], subject, body)
    end
  end

  def self.send_wa(shop)
    if shop.shop_group.owner_wa_tel.present?  
      @template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_renew])
      @data = [shop.shop_group.name, shop.expiration_date]
      
      object_wa = {
        to: shop.shop_group&.owner_wa_tel, 
        from: "system", 
        template: @template, 
        send_purpose: :subscription_update, 
        params: @data
      }
  
      Whatsapp::WhatsappUtility.send_wa_notification(object_wa)
    end
  end

  def self.create_email(receiver, subject, body)
    object_email = {
      to: receiver,
      from: "noreply@otoraja.com",
      subject: subject,
      body: body,
      send_purpose: :subscription_update,
      send_datetime: Date.today.in_time_zone('Jakarta')
    }

    Email::EmailUtility.send_email_notification(object_email)
  end

  def self.subscription_link
    if Rails.env.staging? || Rails.env.development?
      'https://stg-biz.otoraja.id/admin/subscriptions'
    elsif Rails.env.production?
      'https://biz.otoraja.id/admin/subscriptions'
    end
  end
end

SendRenewalSubscriptionReminder.execute