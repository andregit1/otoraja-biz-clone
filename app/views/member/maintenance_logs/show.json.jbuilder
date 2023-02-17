json.maintenance_log do
  json.extract! @maintenance_log, :name, :formated_number_plate, :formated_expiration, :total_price, :amount_paid, :adjustment, :maker, :model, :color
  json.shop_id(@maintenance_log.checkin.shop_id)
  json.shop_name(@maintenance_log.checkin.shop.name)
  json.checkin_id(@maintenance_log.checkin.id)
  json.datetime(formatedDateTime(@maintenance_log.checkin.datetime, 'Jakarta'))
  json.checkout_datetime(formatedDateTime(@maintenance_log.checkin.checkout_datetime, 'Jakarta'))
  json.maintenance_main_mechanic_id(@maintenance_log&.maintained_staff_id)
  json.maintenance_main_mechanic_name(@maintenance_log&.maintained_staff&.name)
  json.maintenance_main_staff_id(@maintenance_log.created_staff_id)
  json.maintenance_main_staff_name(@maintenance_log.created_staff_name)
  json.maintenance_log_payment_methods do
    json.array! @maintenance_log.maintenance_log_payment_methods do |maintenance_log_payment_method|
      json.name(maintenance_log_payment_method.payment_method.name)
      json.amount(maintenance_log_payment_method.amount)
    end
  end
  json.maintenance_log_details do
    json.array! @maintenance_log.maintenance_log_details do |maintenance_log_detail|
      json.extract! maintenance_log_detail, :shop_product_id, :name, :description, :quantity, :unit_price, :sub_total_price, :discount_type, :discount_rate, :discount_amount
      json.maintenance_mechanics do
        json.array! maintenance_log_detail.maintenance_mechanics do |maintenance_mechanic|
          json.id(maintenance_mechanic.shop_staff.id)
          json.name(maintenance_mechanic.shop_staff.name)
        end
      end
    end
  end
end
