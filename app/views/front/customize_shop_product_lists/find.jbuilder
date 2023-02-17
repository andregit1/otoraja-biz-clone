json.set! :customize_shop_product_list do
  json.merge! @customize_shop_product_list.attributes
  json.products_list do
    json.array! @customize_shop_product_list.orderd_shop_products.each do |product|
      json.partial! partial: 'front/shop_products/product_record', locals: { shop_product: product }
    end
  end
end
