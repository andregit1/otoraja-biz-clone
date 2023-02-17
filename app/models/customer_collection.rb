class CustomerCollection
  include ActiveModel::Model
  attr_accessor :customers

  def initialize(attributes = {})
    
    if attributes.present?
      @customers = []
      @shop_id = attributes[:shop_id]
      attributes[:customers].values.each do |attribute|
        unless attribute[:id].blank?
          if Checkin.find_by(customer_id: attribute[:id], shop_id: @shop_id).nil?
            @customers << Customer.find(attribute[:id])
          end
        else
          owned_bike = OwnedBike.new(attribute.slice(:number_plate_area,:number_plate_number,:number_plate_pref,:expiration_month,:expiration_year))
          owned_bike.bike = Bike.new(attribute.slice(:maker,:model,:color))
          customer = Customer.new(attribute.slice(:name,:tel))
          customer.owned_bikes = [owned_bike]
  
          @customers << customer
        end
      end
    end
  end

  def save
    is_success = true
    ActiveRecord::Base.transaction do
      checkins = []
      @customers.each_with_index do |customer,index|
        if customer[:id].nil?
          customer.save!
        end

        checkins << Checkin.new(
          customer_id: customer[:id],
          shop_id: @shop_id,
          datetime: DateTime.now,
          checkout_datetime: DateTime.now,
          deleted: 0,
          created_staff_name: "system",
          created_staff_id: 0,
          updated_staff_name: "system",
          updated_staff_id: 0
        )
      end

      Checkin.import! checkins
    end
    rescue
      is_success = false
    ensure
      return is_success
  end

end
