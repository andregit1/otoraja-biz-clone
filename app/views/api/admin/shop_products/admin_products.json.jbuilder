json.array!(@admin_products) do |product|
  json.id(product.id)
  json.product_no(product.product_no)
  json.name(product.name + ' ' + product.item_detail)
  json.item_detail(product.item_detail)
  json.alias(product.name)
  json.brand_id(product.brand_id)
  json.variant_id(product.variant_id)
  json.tech_spec_id(product.tech_spec_id)
end
