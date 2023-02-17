class Admin::MechanicReportsController < Admin::ApplicationAdminController
  def index
    shop_id = session[:default_user_shop]
    @start_date = params[:start_date] || (Date.today).strftime('%Y-%m-%d 00:00:00')
    @end_date = params[:end_date] || (Date.today).strftime('%Y-%m-%d 23:59:59')
    @select_mechanic = params[:select_mechanic]
    @shop_staffs = ShopStaff.own_shop(shop_id).active_mechanics_by_name

    if @select_mechanic == "0" || @select_mechanic.empty?
      @mechanic_transactions = ShopStaff.get_maintenance_for_range_transaction(shop_id, @start_date, @end_date).select { |record| record.shop_staff_id.nil? }
    else
      @mechanic_transactions = ShopStaff.get_maintenance_for_range_transaction(shop_id, @start_date, @end_date).select { |record| record.shop_staff_id == @select_mechanic.to_i }
    end
  end
end
