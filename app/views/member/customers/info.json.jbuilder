json.member do
  json.partial! partial: 'bike_body', locals: { customer: @customer, bikes: @bikes }
end
