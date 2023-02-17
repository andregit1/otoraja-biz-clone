class AddPeriodMaxDay < ActiveRecord::Migration[5.2]
  def up
    add_column :subscription_periods, :max_day, :int
    SubscriptionPeriod.all.each do |subscription_period|
      subscription_period.max_day = subscription_period.period * 30
      subscription_period.save!
    end
  end
  def down
    remove_column :subscription_periods, :max_day 
  end
end
