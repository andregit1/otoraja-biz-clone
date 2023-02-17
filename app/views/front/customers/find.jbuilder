json.set! :customer do
  json.merge! @customer.attributes
  json.is_pending_verify_tel (@customer.tmp_tel ? true : false)
  json.owned_bikes do
    json.array! @customer.owned_bikes do |owned_bike|
      json.merge! owned_bike.attributes
      json.set! :bike do
        json.merge! owned_bike.bike.attributes
      end if owned_bike.bike.present?
    end
  end if @customer.owned_bikes.present?
end
