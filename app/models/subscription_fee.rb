class SubscriptionFee < ApplicationRecord
  has_many :subscription_plans
  has_many :subscription_periods
  belongs_to :subscription_plan
  belongs_to :subscription_period

  scope :load_plans, ->{
    eager_load(:subscription_plan, :subscription_period)
  }

  def monthly_fee
    self.fee / self.subscription_period.period
  end
end