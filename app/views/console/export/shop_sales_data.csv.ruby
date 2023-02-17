require 'csv'

CSV.generate do |csv|
  column_names = %w(checkin_id datetime shop_name number_plate_area number_plate_number number_plate_pref expiration_month expiration_year product_name product_description quantity unit_price sub_total_price gross_profit discount_type discount_rate discount_amount)
  csv << column_names
  @sales_data.each do |v|
    column_values = [
      v.maintenance_log.checkin.id,
      formatedDateTime(v.maintenance_log.checkin.datetime, 'Jakarta'),
      v.maintenance_log.checkin.shop.name,
      v.maintenance_log.number_plate_area,
      v.maintenance_log.number_plate_number,
      v.maintenance_log.number_plate_pref,
      v.maintenance_log.expiration_month,
      v.maintenance_log.expiration_year,
      v.name,
      v.description,
      v.quantity,
      v.unit_price,
      v.sub_total_price,
      v.gross_profit,
      v.discount_type,
      v.discount_rate,
      v.discount_amount
    ]
    csv << column_values
  end
end