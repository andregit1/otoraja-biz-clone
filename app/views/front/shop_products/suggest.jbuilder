json.array! @shop_products do |shop_product|
  json.partial! partial: 'product_record', locals: { shop_product: shop_product }
end
