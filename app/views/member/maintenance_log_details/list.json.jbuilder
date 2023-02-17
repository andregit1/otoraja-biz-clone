json.items do
  json.array! @items do |item|
    json.name(item.name)
  end
end
