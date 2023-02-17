json.product @shop_products do |product|
    json.id(product.id)
    json.admin_product_no(product.admin_product_product_no)
    json.product_no(product.display_product_no)
    json.shop_id(product.shop_id)
    json.product_category_id(product.product_category_id)
    json.admin_product_id(product.admin_product_id)
    json.shop_alias_name(product.shop_alias_name)
    json.item_detail(product.item_detail)
    json.stock_quantity(product.stock_quantity)
    json.stock_minimum(product.stock_minimum)
    json.sales_unit_price(product.sales_unit_price)
    json.purchase_unit_price(product.purchase_unit_price)
    json.average_price(product.average_price)
    json.remind_interval_day(product.remind_interval_day)
    json.is_stock_control(product.is_stock_control)
    json.is_use(product.is_use)
    json.updated_at(product.updated_at)
    json.formated_stock_quantity(formatedDecimalPoint(product.stock_quantity))
    json.formated_stock_minimum(formatedDecimalPoint(product.stock_minimum))
    json.formated_sales_unit_price(formatedDecimalPoint(product.sales_unit_price))
    json.formated_purchase_unit_price(formatedDecimalPoint(product.purchase_unit_price))
    json.formated_average_price(formatedDecimalPoint(product.average_price))
end

json.meta do
    json.current_page(@shop_products.current_page)
    json.next_page(@shop_products.next_page)
    json.prev_page(@shop_products.prev_page)
    json.total_pages(@shop_products.total_pages)
    json.total_count(@shop_products.total_count)
end

json.paginator(@paginator) 
