json.array! @sales_details_by_product.each_with_index.to_a do |product, index|
  json.no index + 1
  json.name product.name
  json.sold product.sold
end
