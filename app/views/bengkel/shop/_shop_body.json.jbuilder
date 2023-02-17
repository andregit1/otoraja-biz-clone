json.extract! shop, :bengkel_id, :name, :tel, :address, :longitude, :latitude
if has_detail
  json.shop_business_hours do
    json.array! shop.shop_business_hours, :day_of_week, :is_holiday, :open_time, :close_time
  end
end
