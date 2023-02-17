class Admin::SubscriptionsController < Admin::ApplicationAdminController
  before_action :set_shop_group, only:[:index, :create, :detail, :update, :destroy, :change_plan]
  before_action :check_payment_expired, only:[:detail]
  before_action :in_processing_subs_check, only:[:create]
  before_action :payment_gateway_expired_check, only:[:index, :detail]

  def index
    subscriptions = policy_scope(Subscription).where(shop: @selected_shop)
    @subscription_history = subscriptions.shop_plan_subscription.order(id: :desc)
    @extension_history = subscriptions.extension_history.order(id: :desc)
  end

  def show
    @subscription = policy_scope(Subscription).find(params[:id])
    redirect_to pdf_viewer_path(path: receipt_output_for_subscriptions_path(@subscription), back: 'admin_subscriptions_path')
  end

  def detail
    if @selected_shop.payment_gateway_pending?
      @subscription = policy_scope(Subscription).find(@selected_shop.active_plan)
      render :payment
    elsif @selected_shop.have_receipt?
      redirect_to admin_subscriptions_payment_receipt_path(@selected_shop.active_plan)
    else
      redirect_to admin_subscriptions_new_path(@selected_shop.active_plan)
    end
  end

  def new
    begin
      @subscription = policy_scope(Subscription).find(params[:id])
      @period = policy_scope(Subscription).periods[@subscription.period]
      @subscription_history = policy_scope(Subscription).list_plan_subscription(@subscription.shop_id).order(id: :desc)
      @extension_history = policy_scope(Subscription).extension_history_each_shop(@subscription.shop_id).order(id: :desc)
    rescue => exception
      redirect_to admin_subscriptions_path, flash: {danger: I18n.t('reject_access') }
    end
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        response = {}
        shop = policy_scope(Shop).find(params[:shop_id])
        sales_name = shop.active_subscription&.sales_name || current_user.referral

        subscription = Subscription.new(
          shop_group: @shop_group,
          plan: params[:plan].to_i,
          fee: params[:fee].to_i,
          period: params[:period].to_i,
          shop_id: params[:shop_id],
          sales_name: sales_name
        )

        if shop.in_list_payment_gateway? 
          subscription.payment_gateway_transaction(params)
          response['redirect_link'] = admin_subscriptions_details_path
        else
          subscription.manual_transaction
          response['redirect_link'] = admin_subscriptions_path
        end
        render json: response
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.error_subscription') }
    end
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        shop = policy_scope(Shop).find(params[:shop_id])
        subscription = policy_scope(Subscription).find(shop.active_plan)
        response = {}
        if shop.in_list_payment_gateway? 
          subscription.payment_gateway_transaction(params)
          response['redirect_link'] = admin_subscriptions_details_path
        else
          subscription.manual_transaction
          response['redirect_link'] = admin_subscriptions_path
        end
        render json: response
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.error_subscription') }
    end
  end

  def change_plan
    begin
      ActiveRecord::Base.transaction do
        response = {}
        shop = policy_scope(Shop).find(params[:shop_id])
        sales_name = shop.active_subscription&.sales_name || current_user.referral

        if shop.change_plan_time?
          current_subscription = policy_scope(Subscription).find(shop.active_plan) 
          current_subscription.cancel_subscription('Change plan')
          
          subscription = Subscription.new(
            shop_group: @shop_group,
            plan: params[:plan].to_i,
            fee: params[:fee].to_i,
            period: params[:period].to_i,
            shop_id: params[:shop_id],
            sales_name: sales_name
          )
          
          shop = policy_scope(Shop).find(params[:shop_id])
          if shop.in_list_payment_gateway? 
            subscription.payment_gateway_transaction(params)
            response['redirect_link'] = admin_subscriptions_details_path
          else
            subscription.manual_transaction
            response['redirect_link'] = admin_subscriptions_path
          end
          render json: response
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.error_subscription') }
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        subscription = policy_scope(Subscription).find(params[:id])
        if subscription.payment_pending?
          subscription.cancel_payment_gateway_transaction
          subscription.cancel_subscription('Cancel from SMC')
          redirect_to admin_subscriptions_path, notice: I18n.t('subscription.cancelled')
        else
          redirect_to admin_subscriptions_path
        end 
      rescue => e
        logger.error(e.message)
        redirect_to admin_subscriptions_path,flash: {danger: I18n.t('subscription.cancell_error')}
      end
    end
  end

  def payment_proof
    @subscription = policy_scope(Subscription).find(params[:id])
    render :payment_proof, locals: { invalid: false }
  end

  def payment_receipt
    @subscription = policy_scope(Subscription).find(params[:id])
  end

  def upload_payment
    @subscription = policy_scope(Subscription).find(params[:id])
    @subscription.payment_receipt.attach(subscription_payment_params[:payment_receipt])

    if @subscription.payment_receipt.attached?
      redirect_to admin_subscriptions_path, flash: {success: 'Berhasil mengunggah bukti pembayaran Anda.'}
    else
      render :payment_proof, locals: { invalid: true }
    end
  end

  private

  def set_shop_group
    shops = current_user.shops
    @selected_shop = policy_scope(Shop).find(session[:default_user_shop])
    @shop_group = ShopGroup.find(shops.first.shop_group_id)
  end

  def subscription_payment_params
    params.fetch(:subscription,{}).permit(:payment_receipt)
  end

  def check_payment_expired
    selected_shop = policy_scope(Shop).find(session[:default_user_shop])
    if selected_shop.payment_gateway_expired?
      selected_shop.set_payment_gateway_expired
      redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.payment_gateway_expired')} 
    end
  end

  def in_processing_subs_check
    shop = policy_scope(Shop).find(params[:shop_id])
    redirect_to admin_subscriptions_path, flash: {warning: I18n.t('subscription.double_subscription') } if shop.in_processing_subscription?
  end

  def payment_gateway_expired_check
    selected_shop = policy_scope(Shop).find(session[:default_user_shop])
    selected_shop.payment_gateway_expired_update
  end
  
end