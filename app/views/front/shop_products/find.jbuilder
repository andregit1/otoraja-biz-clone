json.set! :shop_product do
  json.partial! partial: 'product_record', locals: { shop_product: @shop_product }
end
