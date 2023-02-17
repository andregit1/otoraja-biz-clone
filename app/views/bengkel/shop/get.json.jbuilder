json.shop do
  json.partial! partial: 'shop_body', locals: { shop: @shop, has_detail: true }
end
