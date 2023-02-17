class Console::ShopConfigsController < Console::ApplicationConsoleController

  before_action :build_country_code_list, only:[:edit, :update]
  before_action :set_shop_tags, only:[:edit, :update]

  def index
    @shop_configs = ShopConfig.own_shop_config(policy_scope(Shop))
  end

  def edit
    @shop_config = ShopConfig.find(params[:id])
    phone = Phonelib.parse(@shop_config.stock_notification_destination)
    @phone_country_code = phone.country_code || '62'
    @phone_national = phone.raw_national
    @grace_period =  @shop_config.shop.grace_period?
  end

  def update
    permited_params = params.require(:shop_config).permit(
      :hour, :min, :questionnaire_expiration_days,
      :front_priority_display,
      :customer_remind_interval_days, :use_customer_remind,
      :use_receipt, :receipt_layout, :receipt_open_expiration_days,
      :use_record_stock, :close_stock_time_hour, :close_stock_time_min,
      :phone_country_code, :phone_national, :use_stock_notification,
      :rounding_direction, :round_to, :num_of_custom_list, :num_of_products_in_custom_list,
      payment_methods:[]
      )
    
    status_change_params = params.require(:shop).permit(
      :subscriber_type,
      :virtual_bank_no,
      :reason_for_cancellation,
      :extension_days,
      :enabled_extend
    )

    jakarta_time = DateTime.now.in_time_zone('Jakarta')
    message_send_time = jakarta_time.change(hour: permited_params[:hour].to_i, min: permited_params[:min].to_i)
    close_stock_time = jakarta_time.change(hour: permited_params[:close_stock_time_hour].to_i, min: permited_params[:close_stock_time_min].to_i)

    @phone_country_code = permited_params[:phone_country_code]
    @phone_national = permited_params[:phone_national]
    tel = permited_params[:phone_country_code] + permited_params[:phone_national] unless permited_params[:phone_national].empty?
    phone = Phonelib.parse(tel)
    tel = phone.international(false)

    @shop_config = ShopConfig.find(params[:id])
    @shop_config.questionnaire_expiration_days = permited_params[:questionnaire_expiration_days]
    @shop_config.message_send_time = message_send_time
    @shop_config.front_priority_display = permited_params[:front_priority_display]
    @shop_config.customer_remind_interval_days = permited_params[:customer_remind_interval_days]
    @shop_config.use_customer_remind = permited_params[:use_customer_remind]
    @shop_config.use_receipt = permited_params[:use_receipt]
    @shop_config.receipt_layout = permited_params[:receipt_layout]
    @shop_config.receipt_open_expiration_days = permited_params[:receipt_open_expiration_days]
    @shop_config.use_record_stock = permited_params[:use_record_stock]
    @shop_config.close_stock_time = close_stock_time
    @shop_config.use_stock_notification = permited_params[:use_stock_notification]
    @shop_config.stock_notification_destination = tel
    @shop_config.rounding_direction = permited_params[:rounding_direction]
    @shop_config.round_to = permited_params[:round_to].to_i
    @shop_config.num_of_custom_list = permited_params[:num_of_custom_list].to_i
    @shop_config.num_of_products_in_custom_list = permited_params[:num_of_products_in_custom_list].to_i

    if status_change_params.present?
      ActiveRecord::Base.transaction do
        @shop_config.shop = @shop
        @subscription = @shop_config.shop.subs_active_plan? if @shop_config.shop.active_plan.present?
        shop_group = @shop.shop_group
        grace_period_date = @shop.grace_period?
        
        if status_change_params[:enabled_extend].present?
          if grace_period_date
            if Date.today > Date.parse(@shop.expiration_date.to_s)
              start_date = grace_period_date > Date.today ? grace_period_date : Date.today
            else
              start_date = grace_period_date > Date.parse(@shop.expiration_date.to_s) ? grace_period_date : Date.parse(@shop.expiration_date.to_s)
            end
          else
            start_date = Date.today > Date.parse(@shop.expiration_date.to_s) ? Date.today : Date.parse(@shop.expiration_date.to_s)
          end
          
          end_date = ApplicationController.helpers.convert_to_weekdays(Date.parse(start_date.to_s) + status_change_params[:extension_days].to_i.days)
          extension_period = Subscription.new(
            shop_group: shop_group,
            plan: 0,
            fee: 0,
            status: :extension_period,
            shop: @shop,
            start_date: start_date,
            end_date: end_date,
          )
          extension_period.save!
        end
        
        if @subscription.present?
          @subscription.reason_for_cancellation = status_change_params[:reason_for_cancellation]
          @subscription.payment_expired = end_date if status_change_params[:extension_days].present?
          @subscription.save!
        end

        @shop.is_reactivated = true if status_change_params[:enabled_extend].present? && @shop.non_subscriber? 
        @shop.subscriber_type = status_change_params[:subscriber_type]
        @shop.virtual_bank_no = status_change_params[:virtual_bank_no]
        @shop.save!
      end
    end

    payment_method_array = []
    permited_params[:payment_methods].each do |payment_method|
      payment_method_array << PaymentMethod.find(payment_method)
    end if permited_params[:payment_methods].present?
    @shop_config.shop.payment_methods = payment_method_array
    
    if @shop_config.save
      redirect_to console_shop_path(@shop_config.shop), flash: {success: 'Configuration was successfully updated.'}
    else
      render :edit
    end
  end

  def search_tags
    items = []
    for item in JSON.parse(params[:data]) do 
      tag = ShopSearchTag.find(item["id"])
      tag.update(
        name: item["name"],
        order: item["order"],
        is_using: item["is_using"]
      )
      items << tag.id
    end
    #set is_using to false any tag not inlcuded 
    all_tags = ShopSearchTag.where("shop_id = #{params[:id]} AND id NOT IN (?)", items)
    count = items.size + 1
    for item in all_tags do
      item.update(is_using: false, order: count)
      count += 1
    end
  end

  private
    def build_country_code_list
      @country_code_list = {
        '+1' => '1',
        '+62' => '62',
        '+81' => '81'
      }
    end

    def set_shop_tags
      @shop = ShopConfig.find(params[:id]).shop
      @subscription = Subscription.find(@shop.active_plan) if @shop.active_plan.present?
      @tags = @shop.shop_search_tags.is_using
    end

end
