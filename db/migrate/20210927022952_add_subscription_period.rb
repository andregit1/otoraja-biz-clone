class AddSubscriptionPeriod < ActiveRecord::Migration[5.2]
  def change
    period = SubscriptionPeriod.create(period: 3, label: "3 Months", max_day: 90)
    SubscriptionFee.create(subscription_period_id: period.id, subscription_plan_id: 2, fee: 360000)
  end
end
