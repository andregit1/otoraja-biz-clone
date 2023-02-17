class CreateSubscriptionPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.timestamps
    end

    create_table :subscription_periods do |t|
      t.string :label
      t.integer :period
      t.timestamps
    end

    create_table :subscription_fees do |t|
      t.references :subscription_plan, index: false
      t.references :subscription_period, index: false
      t.integer :fee
      t.timestamps
    end
    SubscriptionPlan.create(name:"Lite")
    SubscriptionPlan.create(name:"Super")
    SubscriptionPlan.create(name:"Ultimate")
    SubscriptionPeriod.create(period:1, label: "1 Month")
    SubscriptionPeriod.create(period:6, label: "6 Months")
    SubscriptionPeriod.create(period:12, label: "1 Year")
    SubscriptionFee.create(subscription_period_id:1,subscription_plan_id:1,fee:125000)
    SubscriptionFee.create(subscription_period_id:2,subscription_plan_id:1,fee:690000)
    SubscriptionFee.create(subscription_period_id:3,subscription_plan_id:1,fee:125000)
    SubscriptionFee.create(subscription_period_id:1,subscription_plan_id:2,fee:125000)
    SubscriptionFee.create(subscription_period_id:2,subscription_plan_id:2,fee:690000)
    SubscriptionFee.create(subscription_period_id:3,subscription_plan_id:2,fee:125000)
    SubscriptionFee.create(subscription_period_id:1,subscription_plan_id:3,fee:125000)
    SubscriptionFee.create(subscription_period_id:2,subscription_plan_id:3,fee:690000)
    SubscriptionFee.create(subscription_period_id:3,subscription_plan_id:3,fee:125000)
  end
end
