class PaymentType < ApplicationRecord
  belongs_to :payment_gateway
end