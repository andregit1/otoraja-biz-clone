json.array! @product_categories do |category|
  json.merge! category.attributes
  json.set! :product_class do
    json.merge! category.product_class.attributes
  end
end
