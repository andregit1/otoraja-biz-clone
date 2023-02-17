json.shops do
  json.array!(@shops) do |shop|
    json.partial! partial: 'shop_body', locals: { shop: shop, has_detail: false }
  end
end
