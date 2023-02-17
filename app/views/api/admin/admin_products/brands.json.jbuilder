@brands.each do |brand|
    json.set! brand.id, brand.name
end