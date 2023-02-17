json.extract! customer, :id, :name, :tel, :email, :receipt_type, :send_type, :wa_tel, :send_dm, :mypage_terms_agreed_at
json.bikes do
  json.array! bikes, :id, :formated_number_plate, :formated_expiration, :maker, :model, :color
end
