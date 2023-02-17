class PurchaseHistory < ApplicationRecord
  belongs_to :customer
  belongs_to :shop_product
  belongs_to :maintenance_log_detail
end
