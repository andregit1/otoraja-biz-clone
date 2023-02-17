class ExpireSubscription
  def self.execute
    puts "Executing expire subscriptions"
    @expired_subscriptions = Subscription.expired
    unless @expired_subscriptions.empty?
      @template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_expired])
      begin
        @body = I18n.t('subscription.email.body.ops_subscription_expiration')
        @expired_subscriptions.each do | subscription |
          ActiveRecord::Base.transaction do
            subscription.update(status: :expired)
            subscription.shop_group.update(active_plan: nil, expiration_date: nil, subscriber_type: :subscriber)
            @data = [subscription.shop_group.name]
            @body << "\r\n#{subscription.shop_group.name} - #{subscription.end_date}"
            Subscription.send_wa_notification(subscription, @template.template_name, @data)
            Subscription.send_email_notification(subscription.shop_group.owner_email , I18n.t('subscription.email.subject.subscription_expiration'), I18n.t('subscription.email.body.subscription_expiration'))
          end
        end

        Subscription.send_email_notification(ENV['SALES_EMAIL'] , I18n.t('subscription.email.subject.ops_subscription_expiration'), @body )

      rescue => e
        Rails.logger.error(e.message)
      end
    end
  end
end
  
ExpireSubscription.execute
