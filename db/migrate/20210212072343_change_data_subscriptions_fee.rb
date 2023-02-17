class ChangeDataSubscriptionsFee < ActiveRecord::Migration[5.2]
  def change
    subscriptions = SubscriptionFee.where(subscription_plan_id: 2)
    subscriptions.each do |subscription|
      if subscription.subscription_period_id == 1
        subscription.update(fee: 125000)
      elsif subscription.subscription_period_id == 2
        subscription.update(fee: 690000)
      elsif subscription.subscription_period_id == 3
        subscription.update(fee: 1200000)
      end
    end
  end
end
