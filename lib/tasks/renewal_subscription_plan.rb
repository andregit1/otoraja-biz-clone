class RenewalSubscriptionPlan
  def self.execute
    Rails.logger.info('Execute renew Subscription plan')

    today = Date.today.in_time_zone('Jakarta').to_date
    grace_period = today + ENV['PAYMENT_PERIOD'].to_i.days

    shops = Shop.joins(%|LEFT JOIN subscriptions ON shops.active_plan = subscriptions.id|)
            .select("subscriptions.*, shops.*")
            .where('shops.subscriber_type = 2')
            .where('subscriptions.status = 4')
            .where('DATE(expiration_date) = ?', grace_period)
    
    begin
      shops.each do |shop| 
        status = shop.in_list_payment_gateway? ?  :payment_gateway_renewal : :payment_pending
        Rails.logger.info("Renewal subscription for Bengkel:#{shop.name}")
        puts "Renewal subscription for Bengkel:#{shop.name}"
        ActiveRecord::Base.transaction do
          subscription = Subscription.new(
            shop_group: shop.shop_group,
            plan: shop.plan,
            fee: shop.fee,
            period: shop.period,
            status: status,
            payment_expired: grace_period + 14.hours,
            shop: shop,
          )
          subscription.save!
          shop.update!(active_plan: subscription.id)
          subscription.send_renewal_subscription_proforma(Subscription.periods[shop.period].to_i)
        end
      end
    rescue => e
      Rails.logger.error("Abort renew Subscription plan")
      Rails.logger.error("error: #{e.message}")
      puts "Renewal process error: #{e.message}"
    end      
  end  
end
RenewalSubscriptionPlan.execute