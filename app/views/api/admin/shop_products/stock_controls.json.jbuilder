json.array!(@stock_controls) do |stock_control|
  puts stock_control.to_json
  json.id(stock_control.id)
  json.date(stock_control.date)
  json.reason(stock_control.reason)
  json.difference(stock_control.difference)
  json.quantity(stock_control.quantity)
  json.stock_at_close(stock_control.stock_at_close)
  json.shop_invoice_id(stock_control.shop_invoice_id)
  json.formated_quantity(formatedDecimalPoint(stock_control.quantity))
  json.formated_date(formatedDateUseDash(stock_control.date))
  json.formated_difference(formatedDecimalPoint(stock_control.difference))
  json.formated_stock_at_close(formatedDecimalPoint(stock_control.stock_at_close))
end
