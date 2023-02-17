json.array! checkins do |checkin|
  json.merge! checkin.maintenance_log.attributes if checkin.maintenance_log.present?
  json.set! :checkin do
    json.merge! checkin.attributes
    json.checkin_no(checkin.checkin_no)
    json.set! :customer do
      json.merge! checkin.customer.attributes
    end
  end
end
