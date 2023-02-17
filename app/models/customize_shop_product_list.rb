class CustomizeShopProductList < ApplicationRecord
  belongs_to :shop, optional: true
  has_many :customize_shop_product_details, dependent: :destroy
  has_many :shop_products, through: :customize_shop_product_details
  has_many :orderd_shop_products, -> { order('customize_shop_product_details.order asc') }, through: :customize_shop_product_details, :source => :shop_product

  scope :own_shop, ->(shop_ids) {
    where(shop_id: shop_ids)
  }
end
