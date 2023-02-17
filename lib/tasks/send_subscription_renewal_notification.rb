class SendSubscriptionRenewalNotification
  def self.execute
    puts "executing subscription renewal notification"
    @subscription_renewals = Subscription.renewals
    unless @subscription_renewals.empty?
      @template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_renew])
      begin
        @subscription_renewals.each do | subscription |
          @data = [subscription.shop_group.name, subscription, Subscription.days_remaining(subscription)]
          Subscription.send_wa_notification(subscription, @template.template_name, @data)
          Subscription.send_email_notification(subscription.shop_group.owner_email , I18n.t('subscription.email.subject.renewal_notification'), I18n.t('subscription.email.body.renewal_notification') )
        end
      rescue => e
        puts e.message
        Rails.logger.error(e.message)
      end
    end
  end
end

SendSubscriptionRenewalNotification.execute