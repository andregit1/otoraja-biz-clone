json.checkins do
  json.array! @checkins do |checkin|
    json.shop_name(checkin.shop.name)
    json.id(checkin.id)
    json.datetime(formatedDateTime(checkin.datetime, 'Jakarta'))
    json.checkout_datetime(formatedDateTime(checkin.checkout_datetime, 'Jakarta'))
    json.maintenance_log_id(checkin&.maintenance_log&.id)
    json.formated_number_plate(checkin&.maintenance_log&.formated_number_plate)
    json.maker(checkin&.maintenance_log&.maker)
    json.model(checkin&.maintenance_log&.model)
    json.maintenance_log_detail_names do
      json.array! checkin&.maintenance_log&.maintenance_log_details do |maintenance_log_detail|
        json.name(maintenance_log_detail.name)
      end
    end
  end
end
