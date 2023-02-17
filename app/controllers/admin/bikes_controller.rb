class Admin::BikesController < Admin::ApplicationAdminController
  before_action :set_owned_bike, only:[:edit, :update, :update_confirm, :destroy]

  def index
    @q = Bike.ransack(params[:q])
    @bikes = @q.result.order(id: :desc).page(params[:page]).per(10)
  end

  def edit
        
  end

  def update
    if OwnedBike.where.not(id: params[:id]).exists?(number_plate_area: owned_bike_params[:number_plate_area], number_plate_number: owned_bike_params[:number_plate_number], number_plate_pref: owned_bike_params[:number_plate_pref])
      @show_modal = true
      @vehicle_number = "#{owned_bike_params[:number_plate_area]} #{owned_bike_params[:number_plate_number]} #{owned_bike_params[:number_plate_pref]}"
      @all_params = all_params

      render :edit
    else
      update_bike
    end
  end

  def update_confirm
    update_bike
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        @owned_bike.destroy
        @owned_bike.bike.destroy
        redirect_to admin_customer_show_path(@owned_bike.customer), notice: I18n.t('bike.notice.successful_bike_destroyed')
      rescue
        redirect_to admin_customer_show_path(@owned_bike.customer), flash: {danger: I18n.t('bike.notice.unsuccessful_bike_destroyed')}
      end
    end
  end

  private

  def bike_params
    params.require(:owned_bike).permit(:maker, :model, :color, :odometer)
  end

  def owned_bike_params
    params.require(:owned_bike).permit(:number_plate_area, :number_plate_number, :number_plate_pref, :expiration_month, :expiration_year)
  end

  def all_params
    params.require(:owned_bike).permit(:maker, :model, :number_plate_area, :number_plate_number, :number_plate_pref, :expiration_month, :expiration_year, :color)
  end

  def set_owned_bike
    owned_bikes_data = OwnedBike.check_shop_access(params[:id], session[:default_user_shop]).first
    begin
      shop = policy_scope(Shop).find(owned_bikes_data.shop_id)
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access')}
    end
    @owned_bike = OwnedBike.find(params[:id])
  end

  def update_bike
    ActiveRecord::Base.transaction do
      begin
        @owned_bike.update(owned_bike_params)
        @owned_bike.bike.update(bike_params)
        redirect_to admin_customer_show_path(@owned_bike.customer), notice: I18n.t('bike.notice.successful_bike_updated')
      rescue
        redirect_to admin_customer_show_path(@owned_bike.customer), flash: {danger: I18n.t('bike.notice.unsuccessful_bike_updated')}
      end
    end
  end
end
