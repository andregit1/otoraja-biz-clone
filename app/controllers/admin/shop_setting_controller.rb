class Admin::ShopSettingController < Admin::ApplicationAdminController
  before_action :set_shop, only: [:edit_branch, :update_branch]

  def index
    @owner = current_user.shops.first&.shop_group
  end

  def new_branch
    begin
      @shop = Shop.new
      @shop.shop_group = current_user.shops.first&.shop_group
      authorize @shop

      SearchTag.all.each do |t|
        @shop.shop_search_tags.build('order': t.id, 'name': t.tag, 'is_using': true)
      end

      ShopBusinessHour.day_of_weeks.each do |v|
        @shop.shop_business_hours.build('day_of_week': v[0], 'is_holiday': true)
      end
    rescue => exception
      redirect_to root_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def create_branch
    begin
      ActiveRecord::Base.transaction do
        period = 1
        shop_group = current_user.shops.first&.shop_group
        start_date = DateTime.now.beginning_of_day
        expiration_date = Shop.subscription_end_period(start_date, period)
        
        @shop = Shop.new(shop_params)
        @shop.expiration_date = expiration_date
        @shop.initial_setup = false
        @shop.subscriber!
        @shop.save!

        subscription = Subscription.new(
          shop_group: shop_group,
          plan: 0,
          fee: 0,
          period: period,
          status: :demo_period,
          shop: @shop,
          start_date: start_date,
          end_date: expiration_date,
          payment_date: Date.today
        )
        subscription.save!
        @shop.update!(active_plan: subscription.id)

        AvailableShop.create(shop: @shop, user: current_user)
      end
      redirect_to admin_shop_setting_path, flash: {success: 'Cabang bengkel berhasil dibuat. Cek masa berlaku di menu Langganan.'}
    rescue ActiveRecord::RecordInvalid => e
      @shop.shop_group = current_user.shops.first&.shop_group
      render :new_branch
    end
  end

  def delete_logo
    shop = policy_scope(Shop).find(params[:id])
    shop.shop_logo.purge
    redirect_to admin_shop_setting_edit_branch_path(shop.id)
  end

  def edit_owner
    if current_user.owner?
      @owner = current_user.shops.first&.shop_group
      @user = current_user
    else
      redirect_to admin_shop_setting_path
    end
  end

  def edit_branch
    unless @shop.shop_business_hours.present?
      ShopBusinessHour.day_of_weeks.each do |v|
        @shop.shop_business_hours.build('day_of_week': v[0], 'is_holiday': true)
      end
    end
  end

  def update_owner
    @owner = current_user.shops.first&.shop_group
    if @owner.update(owner_params)
      redirect_to admin_shop_setting_path, flash: {success: 'Data pemilik berhasil diubah.'}
    else
      render :edit_owner
    end
  end

  def update_branch
    jakarta_time = DateTime.now.in_time_zone('Jakarta')
    config = shop_config_params[:shop_config_attributes]
    close_stock_time = jakarta_time.change(hour: config[:close_stock_time_hour].to_i, min: config[:close_stock_time_min].to_i)
    shop_config = ShopConfig.find(config[:id])
    
    shop_config.use_stock_notification = config[:use_stock_notification]
    shop_config.close_stock_time = close_stock_time
    shop_config.stock_notification_destination = config[:stock_notification_destination]
    @shop.assign_attributes(shop_params)

    if @shop.valid?(:update_shop) && @shop.save && shop_config.save
      redirect_to admin_shop_setting_path, flash: {success: 'Data bengkel berhasil diubah'}
    else
      render :edit_branch
    end
  end

  def update_password
    unless current_user.owner?
      redirect_to admin_shop_setting_path
    end

    @owner = current_user.shops.first&.shop_group
    @user = policy_scope(User).find(current_user.id)
    @user.password_updated_at = DateTime.now
    
    if password_params[:password].blank?
      @user.errors.add(:password, :blank)
      render :edit_owner
      return
    end

    if @user.update_with_password(password_params)
      redirect_to admin_shop_setting_path, flash: {success: 'Password bengkel berhasil diubah'}
    else
      render :edit_owner
    end
  end

  private
  def set_shop
    @shop = current_user.shops.find(params[:shop_id])
  end

  def owner_params
    params.fetch(:shop_group, {}).permit(:owner_name, :owner_tel, :owner_tel2)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def shop_params
    params.fetch(:shop, {}).permit(
      :shop_group_id,
      :name,
      :tel,
      :shop_logo,
      :tel2,
      :tel3,
      :address,
      :region_id,
      :province_id,
      :regency_id,
      {:facility_ids => []},
      {:service_ids => []},
      shop_business_hours_attributes: [:id, :shop_id, :is_holiday, :day_of_week, :open_time_hour, :open_time_minute, :close_time_hour, :close_time_minute, :_destroy],
      shop_search_tags_attributes: [:id, :name, :order, :is_using]
      
    )
  end

  def shop_config_params
    params.fetch(:shop, {}).permit(
      shop_config_attributes: [:id, :close_stock_time_hour, :close_stock_time_min, :stock_notification_destination, :use_stock_notification]
    )
  end
end