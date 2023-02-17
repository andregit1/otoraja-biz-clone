json.owned_bike do
  json.extract! @owned_bike, :id, :formated_number_plate, :formated_expiration, :maker, :model, :color
end
