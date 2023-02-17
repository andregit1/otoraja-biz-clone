json.array! @product_list.each_with_index.to_a do |product, index|
  json.no index + 1
  json.name product.shop_alias_name
  json.quantity product.quantity
end
