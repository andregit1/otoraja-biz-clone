class ShopAvailablePaymentMethod < ApplicationRecord
  belongs_to :shop
  belongs_to :payment_method

  scope :own_shop_config, ->(shops) {
    where(shop_available_payment_methods: { shop: shops } )
  }
end
