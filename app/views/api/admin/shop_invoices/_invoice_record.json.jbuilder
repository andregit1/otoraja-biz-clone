json.id(invoice.id)
json.shop_id(invoice.shop_id)
json.invoice_no(invoice.invoice_no)
json.supplier_id(invoice.supplier_id)
json.arrival_date(invoice.arrival_date)
json.payment_method(invoice.payment_method)
json.updated_at(invoice.updated_at)
json.status(invoice.status)

if invoice.supplier.present?
  if invoice.status == "closed"
    json.supplier_name(invoice.supplier.name)
  else
    if invoice.supplier.deleted_at.blank?
      json.supplier_name(invoice.supplier.name)
    end
  end
end

json.shop_products do
  json.array!(invoice.stock_controls) do |stock_control|
    json.merge! stock_control.attributes
    json.merge! stock_control.shop_product.attributes
    json.set! :product_stock, stock_control.shop_product.stock.nil? ? 0 :stock_control.shop_product.stock.quantity
    json.set! :stock_control_id, stock_control.id
  end
end 
