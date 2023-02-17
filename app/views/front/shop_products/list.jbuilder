json.array! @customize_shop_product_lists do |customize_list|
  json.merge! customize_list.attributes
  json.products_list do
    json.array! customize_list.orderd_shop_products.each do |product|
      json.partial! partial: 'product_record', locals: { shop_product: product }
    end
  end
end
