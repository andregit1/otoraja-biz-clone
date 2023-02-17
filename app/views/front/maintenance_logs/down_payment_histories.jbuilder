json.set! :down_payment_histories do
  json.array! @down_payment_histories do |down_payment_history|
    json.merge! down_payment_history.attributes
  end
end