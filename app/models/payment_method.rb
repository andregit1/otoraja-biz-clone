class PaymentMethod < ApplicationRecord
  has_many :shop_available_payment_methods
  has_many :maintenance_log_payment_methods
end
