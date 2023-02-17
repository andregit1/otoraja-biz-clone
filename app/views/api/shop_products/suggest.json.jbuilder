json.array!(@shop_products) do |shop_product|
  json.id(shop_product.id)
  json.product_no(shop_product.product_no)
  json.product_category_id(shop_product.product_category_id)
  json.product_category_name(shop_product.product_category.name)
  json.admin_product_name(shop_product.admin_product_name)
  json.shop_alias_name(shop_product.shop_alias_name)
  json.product_name(shop_product.product_name)
  json.stock_minimum(shop_product.stock_minimum)
  json.stock(shop_product.stock_quantity || '--')
  json.sales_unit_price(shop_product.sales_unit_price || 0)
  json.is_stock_control(shop_product.is_stock_control)
  json.inclusion_products do
    json.array! shop_product.packaging_product_relations_packaging do |inclusion_product|
      json.id(inclusion_product.inclusion_product.id)
      json.product_no(inclusion_product.inclusion_product.product_no)
      json.item_name(inclusion_product.inclusion_product.shop_alias_name)
      json.category_name(inclusion_product.inclusion_product.product_category.name)
      json.item_detail(inclusion_product.inclusion_product.item_detail)
      json.quantity(inclusion_product.quantity)
      json.stock(inclusion_product.inclusion_product&.stock_quantity || '--')
    end
  end if shop_product.has_inclusion_product?
end
