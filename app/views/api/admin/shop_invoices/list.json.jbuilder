json.invoices @shop_invoices do |invoice|
  json.partial! partial: 'invoice_record', locals: { invoice: invoice }
end

json.paginator(@paginator)