class CustomizeShopProductDetail < ApplicationRecord
  belongs_to :customize_shop_product_detail, optional: true
  belongs_to :shop_product, optional: true
end
