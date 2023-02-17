class Console::SubscriptionsController < Console::ApplicationConsoleController
  def index
    #search data
    @shop_groups = ShopGroup.all.order("id ASC")
    @statuses = Subscription.statuses
    @periods = SubscriptionPeriod.all.order(:period)
    @plans = SubscriptionPlan.all.order("id ASC")

    #set search params and default null
    @select_shop_group = params[:shop_group_id_eq].present? ? params[:shop_group_id_eq] : nil
    @select_status = params[:status_eq].present? ? params[:status_eq] : nil
    @select_period = params[:period_eq].present? ? params[:period_eq] : nil
    @select_plan = params[:plan_eq].present? ? params[:plan_eq] : nil

    order = params[:sort] || "subscriptions.id DESC"
    @q = Subscription.get_shop_group.order(order).where.not(status: [:extension_period, :demo_period]).ransack(params)
    @subscriptions = @q.result.page(params[:page]).per(10).order(order)
  end

  def invoice
    order = params[:sort] || "subscriptions.id DESC"
    @q = Subscription.list_with_shop.ransack(params[:q])
    @subscriptions = @q.result.page(params[:page]).per(10).order(order)
  end

  def export_invoice_report
    order = params[:sort] || "subscriptions.id DESC"
    @q = Subscription.list_with_shop.select('subscriptions.*', 'shops.name as shop_name', 'shops.bengkel_id' ).ransack(params[:q])

    case params[:q][:checkbox]
    when "id"
      ids = params[:q][:checkbox_ids].split(",").map(&:to_i)
      @subscriptions = @q.result.where('subscriptions.id IN (?)', ids).order(order)
    when "page"
      @subscriptions = @q.result.page(params[:q][:page]).per(10).order(order)
    when "all"
      @subscriptions = @q.result.order(order)    
    end
    
    respond_to do |format|
      format.csv {
        send_data export_invoice_csv, filename: "subscription_invoice_#{Time.zone.now.strftime('%Y%m%d')}.csv"
      }
    end
  end

  def new
    
  end

  def create
    
  end

  def edit
    @subscription = Subscription.find(params[:id].to_i)
    # for old data handling shop_id null , event move to subscription by shop
    if @subscription.shop_id.nil?
      shop_group_id = ShopGroup.find(@subscription.shop_group_id)
      shop = Shop.find_by(shop_group_id: shop_group_id)
      @subscription.update(
        shop: shop
      )
    end
    #Calculate Days remaining
    @days_remaining = @subscription.days_remaining
    @buttond_date_cancel = (@subscription.end_date.present? && @subscription.end_date <= DateTime.now)
  end

  def update
    @subscription = Subscription.find(params[:id].to_i)
    ActiveRecord::Base.transaction do
      begin
        new_status = subscription_params[:new_status].to_i
        #Calculate Days remaining
        @days_remaining = @subscription.days_remaining
        #starting application process
        if new_status == Subscription.statuses[:creating_bank_account]
          @subscription.update!(status: new_status, va_code_area_id: subscription_params[:va_code_area_id], sales_name: subscription_params[:sales_name])
        #bank account has been created
        elsif new_status == Subscription.statuses[:payment_pending]
          @subscription.update_payment_pending(subscription_params[:virtual_bank_no])
          @subscription.send_creating_bank_account_notification
          @subscription.send_ops_payment_pending_notification
        # payment received send notif to customer
        elsif new_status == Subscription.statuses[:payment_confirmed]
          @subscription.update!(status: new_status)
        #payment received. ops will trigger the finalization at this point
        elsif new_status == Subscription.statuses[:finalized]
          @subscription.update_finalization(subscription_params)
          @subscription.send_payment_received_notification
        end
      rescue => e
        logger.error(e.message)
      end
    end
    
    render :edit
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        Subscription.find(params[:id]).cancel_subscription('Cancel from Host')
        redirect_to console_subscriptions_path, notice: I18n.t('subscription.cancelled')
      end
    rescue => exception
      logger.error(exception.message)
      redirect_to console_subscriptions_path, flash: {danger: I18n.t('subscription.cancell_error') }
    end
  end
  
  private
  def subscription_params
    params.fetch(:subscription,{}).permit(:id, :days_remaining, :virtual_bank_no, :new_status, :invoice_number, :form_number, :payment_date, :va_code_area_id, :sales_name, {shop_ids: []})
  end

  def export_invoice_csv
    csv_str = CSV.generate do |csv|
      column_names = %w(No No_Invoice Nama_Bengkel Bengkel_ID Tgl_Invoice Jatuh_Tempo Jumlah_RP Item Order_ID Metode_Bayar No_VA Nama_Sales Tgl_Bayar)
      csv << column_names
      @subscriptions.each_with_index do |item, index|
        column_values = [
          index + 1,
          item.invoice_number.to_s,
          item.shop_name,
          item.bengkel_id,
          item.payment_date&.strftime('%d-%m-%Y'),
          item.payment_expired&.strftime('%d-%m-%Y'),
          item.fee,
          Subscription.periods_i18n[item.period],
          item.order_ids.to_s,
          item.payment_type_id,
          item.sales_name,
          item.payment_date&.strftime('%d-%m-%Y')
        ]
        csv << column_values
      end
  end
  end
end
