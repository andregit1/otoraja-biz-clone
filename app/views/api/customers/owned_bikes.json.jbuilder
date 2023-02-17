json.array!(@owned_bikes) do |owned_bike|
  json.id(owned_bike.id)
  json.number_plate_area(owned_bike.number_plate_area)
  json.number_plate_number(owned_bike.number_plate_number)
  json.number_plate_pref(owned_bike.number_plate_pref)
  json.expiration_month(owned_bike.expiration_month)
  json.expiration_year(owned_bike.expiration_year)
  json.maker(owned_bike.maker)
  json.model(owned_bike.model)
  json.color(owned_bike.color)
end
