class Admin::SubscriptionPlanController < Admin::ApplicationAdminController
  before_action only:[:new,:create,:cancel,:destroy]
  before_action :set_payment_method, only:[:show, :continue_payment]
  before_action :in_processing_subs_check, only:[:new]
  
  # def index
      
  # end

  def new
    begin
      @shop_id = params[:shop_id]
      plan = voucher_generator(params)
      @subscriptions = SubscriptionFee.load_plans.where(subscription_plan_id: plan).order("subscription_periods.period")
      shop_active_subscription = Subscription.active_shop_subscription(@shop_id)
      @shop = policy_scope(Shop).find(@shop_id)
      @subscription = Subscription.new()
      #enable buttons if there is no active subscription or if the current subscription is finalized
      @disable = (shop_active_subscription.nil?) ? false : shop_active_subscription.status != 4
    rescue => exception
      redirect_to admin_subscriptions_path, flash: {danger: I18n.t('reject_access') }
    end
  end

  def show
    params = subscription_plan_params
    @plan_id = params[:plan]
    @shop_id = params[:shop_id]
    @period = params[:period]
    @fee = params[:fee]
    @method = :post
    @url = admin_subscriptions_path
    
    begin
      @shop = policy_scope(Shop).find(@shop_id)
    rescue => exception
      redirect_to admin_subscriptions_path, flash: {danger: I18n.t('reject_access') }
    end

    if @shop.change_plan_time?
      @url = admin_subscriptions_change_plan_path
      @is_change_plan = true;
    end
  end

  def payment_method_check
    result = {}
    payment_gateway = PaymentGateway.find_by(is_active: true)
    result['payment_gateway'] = payment_gateway
      
    if payment_gateway.present?
      result['payment_method_service'] = Payment::PaymentUtility.getPaymentTypeDetail(params[:payment_type_id])
      result['payment_method_smc'] = PaymentType.find(params[:payment_type_id])
    end
    
    render json: result
  end

  def status_subscription_check
    shop = policy_scope(Shop).find( params[:shop_id])
    response = {in_processing: shop.in_processing_subscription?}
    render json: response
  end

  def change_plan
    plan = voucher_generator(params)
    shop = policy_scope(Shop).find(params[:shop_id])
    redirect_to admin_subscriptions_path unless shop.change_plan_time?
    begin
      @shop_id = params[:shop_id]
      @subscriptions = SubscriptionFee.load_plans.where(subscription_plan_id: plan).order("subscription_periods.period")
      @subscription = Subscription.new()
      shop_active_subscription = Subscription.active_shop_subscription(@shop_id)
      render :new
    rescue => exception
      redirect_to admin_subscriptions_path, flash: {danger: I18n.t('reject_access') }
    end
  end

  def continue_payment   
    begin
      params = subscription_plan_params

      @shop_id = params[:shop_id]
      @plan_id = params[:plan]
      @period = params[:period]
      @fee = params[:fee]
      @shop = policy_scope(Shop).find(@shop_id)
      subscription_id = @shop.active_subscription&.id
      @method = :patch
      @url = admin_subscription_path(subscription_id)
      @continue_payment = true;
      
      render :show
    rescue => exception
      logger.error(exception.message)
      redirect_to admin_subscriptions_path
    end
  end

  def download_qrcode
    require "open-uri"
    url = Shop.find(session[:default_user_shop]).active_subscription.qr_path
    send_data open(url).read, filename: "qrcode.png", type: "image/png", disposition: "attachment"
  end

  private

  def subscription_plan_params
    params.fetch(:subscription,{}).permit(:id, :plan, :fee, :period, :shop_id)
  end
    
  def set_payment_method
    @payment_gateway = PaymentGateway.find_by(is_active: true)
    @shop = Shop.find(subscription_plan_params[:shop_id])
    if @payment_gateway
      shop_methods = @shop.payment_type_list
      use_all_methods = PaymentType.where(is_use_all: true, is_active: true)
      @payment_methods = PaymentType.find_by_sql("#{use_all_methods.to_sql} UNION #{shop_methods.to_sql}")
    end
  end
  
  def in_processing_subs_check
    id = params[:shop_id].present? ? params[:shop_id] : subscription_plan_params[:shop_id]
    shop = policy_scope(Shop).find(id)
    redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.double_subscription') } if shop.in_processing_subscription?
  end

  def voucher_generator(params)
    magic_number = 276917
    tanggal = Date.today.in_time_zone('Jakarta').strftime('%Y%m%d').to_i
    prefix = 'ORNTEST'
    code = "#{prefix}#{tanggal * magic_number}"
    return params[:code] == code ? [2, 4] : [2]
  end

end