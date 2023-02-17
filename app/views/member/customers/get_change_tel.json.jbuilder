json.customer_tel do
  json.extract! @customer, :id, :name, :tel, :tmp_tel
end
