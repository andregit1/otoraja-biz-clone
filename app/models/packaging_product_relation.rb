class PackagingProductRelation < ApplicationRecord
  belongs_to :packaging_product, class_name: 'ShopProduct', optional: true
  belongs_to :inclusion_product, class_name: 'ShopProduct', optional: true

  scope :own_shop, ->(shop_ids) {
    joins(:packaging_product).where(shop_products: {shop_id: shop_ids})
  }
end
