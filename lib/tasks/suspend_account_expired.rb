class SuspendAccountExpired
  def self.execute
    puts "Execute Suspend Subscription expired"

    current_time = Date.today.in_time_zone('Jakarta')
    paid_without_active_plan =  Shop.where(subscriber_type: :paid_subscriber).where('active_plan IS NULL AND DATE(expiration_date) <= ?', current_time.to_date)
    expired_paid_shop = Shop.joins(:subscriptions)
                        .where(subscriber_type: :paid_subscriber)
                        .where('active_plan = subscriptions.id')
                        .where('DATE(expiration_date) <= ?', current_time.to_date)
                        .where('subscriptions.payment_expired <= expiration_date OR subscriptions.payment_gateway_expired <= ?', current_time)
    grace_period_shop = Shop.joins(:subscriptions)
                        .where.not(subscriber_type: :non_subscriber)
                        .where('subscriptions.payment_expired <= ?', current_time.to_date + 14.hours)
                        .where('active_plan = subscriptions.id')
                        .where('subscriptions.payment_expired > expiration_date')
    expired_demo_shop = Shop
                        .where(subscriber_type: :subscriber)
                        .where('DATE(expiration_date) <= ?', current_time.to_date)
    extension_expired = Shop
                        .joins(%|
                          INNER JOIN
                          (SELECT
                            shop_id,
                            max(end_date) as end_date
                          FROM
                            subscriptions
                          WHERE
                            status = 8
                          GROUP BY shop_id 
                          ) as extension 
                          ON extension.shop_id = shops.id
                        |)
                        .where('DATE(extension.end_date) <= ?', current_time.to_date)
                        .where(is_reactivated: true)
    paid_shops = Shop.find_by_sql("#{expired_paid_shop.to_sql} UNION #{grace_period_shop.to_sql} UNION #{paid_without_active_plan.to_sql}")

    begin
      # Suspend Paid subscription
      paid_shops.each do |paid_shop| 
        ActiveRecord::Base.transaction do
          if paid_shop.active_plan.present?
            subscription = Subscription.find(paid_shop.active_plan)
            subscription.update!(status: :expire, reason_for_cancellation: "expiration date") if subscription.finalized?
            plan = subscription.plan_i18n
            subscription_id = subscription&.order_ids
          else
            plan = 'BERBAYAR'
            subscription_id = "#{paid_shop.id}#{rand(10000..99999)}"
          end
          send_wa(paid_shop, plan)
          send_email(paid_shop, subscription_id, plan)
          paid_shop.update!(subscriber_type: :non_subscriber, is_reactivated: false)
          puts "Paid Shop Expired: #{paid_shop.name}"
        end
      end
    
      # Suspend Demo subscription
      expired_demo_shop.each do |demo_shop| 
        ActiveRecord::Base.transaction do
          send_wa(demo_shop)
          send_email(demo_shop)
          demo_shop.update!(subscriber_type: :non_subscriber, is_reactivated: false)
          puts "Demo Shop Expired: #{demo_shop.name}"
        end
      end
    
      # Non active extension shop
      extension_expired.each do |extension_shop|
        ActiveRecord::Base.transaction do
          extension_shop.update!(is_reactivated: false)
          puts "Suspend shop have extension: #{extension_shop.name}"
        end
      end
    rescue => e
      puts "Abort Suspend Subscription expired"
      puts "error: #{e.message}"
    end      
  end

  def self.send_wa(shop, plan = "Demo")
    if shop.shop_group.owner_wa_tel.present?      
      object = {
        from: "system",
        template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_account_suspended_v2]),
        params:  [shop.name, plan],
        to: shop.shop_group.owner_wa_tel, 
        send_purpose: :subscription_update
      }
  
      Whatsapp::WhatsappUtility.send_wa_notification(object)
    end
  end

  def self.send_email(shop, subscription_id = "", plan = "Demo")
    subject = I18n.t('subscription.email.subject.expired', id: subscription_id)
    body = I18n.t('subscription.email.body.expired', shop_name: shop.name, plan: plan)
    
    if shop.shop_group.owner_email.present?
      create_email(shop.shop_group.owner_email, subject, body)
    end
    
    phone_number = sanitize_phone_number(shop.shop_group&.owner_wa_tel)
    if shop.shop_group.owner_email.blank? && phone_number.blank?   
      create_email(ENV['PRODUCT_EMAIL'], subject, body)
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

  def self.sanitize_phone_number(phone)
    if phone&.first(2) == '08'
      return phone
    elsif phone&.first(2) == '62'
      return "+" + phone
    end
  end
end
  
SuspendAccountExpired.execute