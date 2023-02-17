@variants.each do |variant|
    json.set! variant.id, variant.name
end