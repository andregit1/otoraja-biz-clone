json.set! :invoice do
  json.partial! partial: 'invoice_record', locals: { invoice: @shop_invoice }
end
