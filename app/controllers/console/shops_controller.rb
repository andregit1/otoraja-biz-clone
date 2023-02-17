class Console::ShopsController < Console::ApplicationConsoleController
  before_action :set_shop, only: [:show, :edit, :update]

  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result(distinct: true)
    .order(id: :desc)
    .page(params[:page]).per(10)

    if params[:pilot_shops].present?
      @shops = @shops.pilot_shops
    end
  end

  def new
    @shop = Shop.new
    ShopBusinessHour.day_of_weeks.each do |v|
      @shop.shop_business_hours.build('day_of_week': v[0])
    end
  end

  def edit

  end

  def create
    try = 0
    begin
      try += 1
      ActiveRecord::Base.transaction do
        period = 1
        start_date = DateTime.now.beginning_of_day
        expiration_date = Shop.subscription_end_period(start_date, period)


        @shop = Shop.new(shop_params)
        @shop.expiration_date = expiration_date
        @shop.subscriber!
        @shop.save!
        
        subscription = Subscription.new(
          shop_group: @shop.shop_group,
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
      end

      redirect_to console_shop_path(@shop), flash: {success: 'Shop was successfully created.'}
    rescue ActiveRecord::RecordInvalid => e
      render :new
    rescue
      retry if try < 3
      raise
    end
  end

  def update
    @shop.assign_attributes(shop_params)
    if @shop.save
      redirect_to console_shop_path(@shop), flash: {success: 'Shop was successfully updated.'}
    else
      render :edit
    end
  end

  def show
  end

  def import_expiration
    @shop_expiration_upload = ShopExpiredUpload.new
  end

  def import_expiration_execution
    @shop_upload = ShopExpiredUpload.new(shop_expired_params)
    if @shop_upload.valid?
      @imports = @shop_upload.import_expiration_date
      respond_to do |format|
        format.js { flash.now[:info] = "Update expiration shops has been successful." }
      end
    end
  end

  def import_subscription
    @shop_subscription_upload = ShopSubscriptionUpload.new
  end

  def import_subscription_execution
    @shop_upload = ShopSubscriptionUpload.new(shop_subscription_params)
    if @shop_upload.valid?
      @imports = @shop_upload.import_subscription_data
      @subscription = true
      respond_to do |format|
        format.js { flash.now[:info] = 'Adding Shop subscription has been successful.' }
      end
    end
  end

  def export_shop_list_report
    order = params[:sort] || "shops.id DESC"
    @q = Shop.ransack(params[:q]).result

    @shops = case params[:q][:checkbox]
    when "id"
      ids = params[:q][:checkbox_ids].split(",").map(&:to_i)
      @q.where(id: ids).order(order)
    when "page"
      @q.page(params[:q][:page]).per(10).order(order)
    when "all"
      @q.order(order)    
    end
    
    respond_to do |format|
      format.csv {
        send_data export_invoice_csv, filename: "shops_list_#{Time.zone.now.strftime('%Y%m%d')}.csv"
      }
    end
  end

  private
    def set_shop
      @shop = Shop.find(params[:id])
      whats_app_services = WhatsAppService.all
      whats_app_services.each do |service|
        shop_whats_app_template = ShopWhatsAppTemplate.where(shop_id: @shop.id, whats_app_service_id: service.id).first
        unless shop_whats_app_template.nil?
          service.whats_app_template_id = shop_whats_app_template.whats_app_template_id
        end
      end
      @whats_app_services = whats_app_services
      @defaults = WhatsAppService.pluck(:whats_app_template_id)
      @whats_app_available_templates = WhatsAppTemplate.get_production_templates().where.not(id: @defaults).all.pluck(:template_name, :id)
      @tags = ShopSearchTag.own_shop(params[:id]).is_using()
    end

    def shop_params
      params.fetch(:shop, {}).permit(
        :name,
        :shop_group_id,
        :tel,
        :tel2,
        :tel3,
        :address,
        :region_id,
        :province_id,
        :regency_id,
        :latitude,
        :virtual_bank_no,
        :longitude,
        {:facility_ids => []},
        {:service_ids => []},
        shop_business_hours_attributes: [:id, :shop_id, :is_holiday, :day_of_week, :open_time_hour, :open_time_minute, :close_time_hour, :close_time_minute, :_destroy]
      )
    end

    def shop_expired_params
      params.fetch(:shop_expired_upload, {}).permit(:file)
    end

    def shop_subscription_params
      params.fetch(:shop_subscription_upload, {}).permit(:file)
    end

    def export_invoice_csv
      csv_str = CSV.generate do |csv|
        column_names = %w(No Bengkel_ID Bengkel_name Status Kode_Area Item No_Berlangganan No_Virtual_Akun Nama_Sales Tgl_Daftar Masa_Berlaku New_atau_Ext)
        csv << column_names
        @shops.each_with_index do |shop, index|
          last_subscription = shop.subscriptions.last
          period = last_subscription&.period && Subscription.periods[last_subscription&.period] > 1 ? Subscription.periods[last_subscription&.period] : ""
          item = period.present? ? t("console.shop.package", period: period) : ""
          status = nil
      
          unless shop.nil? 
            status = if shop.non_subscriber? 
             Shop.human_attribute_name('subscriber_type.non_subscriber')
            elsif shop.subscriber? 
             Shop.human_attribute_name('subscriber_type.subscriber')
            elsif shop.paid_subscriber? 
             Shop.human_attribute_name('subscriber_type.paid_subscriber')
            end 
          end 

          if params[:q].present?
            next if params[:q][:subscriptions_period_eq].present? && params[:q][:subscriptions_period_eq].to_i!=Subscription.periods[last_subscription.period]
            next if params[:q][:subscriptions_va_code_area_va_code_eq].present? && params[:q][:subscriptions_va_code_area_va_code_eq].to_i!=last_subscription&.va_code_area&.va_code
            next if params[:q][:subscriptions_sales_name_cont].present? && params[:q][:subscriptions_sales_name_cont]!=last_subscription&.sales_name
          end

          column_values = [
            index + 1,
            shop.bengkel_id,
            shop.name,
            status,
            last_subscription&.va_code_area&.va_code,
            item,
            last_subscription&.order_ids,
            shop.virtual_bank_no,
            last_subscription&.sales_name,
            shop.created_at.strftime("%d-%m-%Y"),
            shop.expiration_date&.strftime("%d-%m-%Y"),
            shop.is_reactivated? ? "Ext" : "New"
          ]

          csv << column_values
        end
      end
    end
end
