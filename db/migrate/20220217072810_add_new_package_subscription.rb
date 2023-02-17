class AddNewPackageSubscription < ActiveRecord::Migration[5.2]
  def change
    subscription_plan = SubscriptionPlan.create(name:"_Testing_payment_gateway_")
    SubscriptionFee.create(subscription_plan: subscription_plan, subscription_period_id: 1, fee: 10000)
  end
end
