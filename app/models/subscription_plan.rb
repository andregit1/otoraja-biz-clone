class SubscriptionPlan < ApplicationRecord
  has_many :subscription_fees
end