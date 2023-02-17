class Member::OwnedBikesController < Member::MemberController
  def show
    @owned_bike = OwnedBike.find_by(id: params[:bike_id], customer: @customer)
  end

  def update
    ownedBike = OwnedBike.find_by(id: params[:bike_id], customer: @customer)
    if ownedBike.present?
      ownedBike.update(owned_bike_params)
      if ownedBike.bike.present?
        ownedBike.bike.update(bike_params)
      end
    end
  end

  private
  def owned_bike_params
    params.permit(:number_plate_area, :number_plate_number, :number_plate_pref, :expiration_month, :expiration_year)
  end

  def bike_params
    params.permit(:maker, :model, :color)
  end
end

