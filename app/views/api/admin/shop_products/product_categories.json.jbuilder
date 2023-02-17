@product_categories.each do |category|
  json.set! category.id, category.name
end
