json.array!(shop_search_tags) do |shop_search_tag|
    json.id(shop_search_tag.id)
    json.shop_id(shop_search_tag.shop_id)
    json.tag(shop_search_tag.tag)
    json.name(shop_search_tag.name)
    json.order(shop_search_tag.order)
end