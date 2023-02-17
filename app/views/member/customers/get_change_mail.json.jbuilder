json.customer_mail do
  json.extract! @customer, :id, :name, :email, :tmp_email
end
