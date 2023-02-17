json.array!(@variants) do |variant|
  json.id(variant.id)
  json.name(variant.name)
end
