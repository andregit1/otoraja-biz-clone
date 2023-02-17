json.product @shop_products do |product|
    json.id(product.id)
    json.shop_id(product.shop_id)
    json.shop_alias_name(product.shop_alias_name)
    json.product_category_id(product.product_category_id)
    json.item_detail(product.item_detail)
end

json.meta do
    json.current_page(@shop_products.current_page)
    json.next_page(@shop_products.next_page)
    json.prev_page(@shop_products.prev_page)
    json.total_pages(@shop_products.total_pages)
    json.total_count(@shop_products.total_count)
end

json.paginator(@paginator) 
