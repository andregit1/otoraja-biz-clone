class Admin::ShopConfigsController < Admin::ApplicationAdminController
  before_action :build_country_code_list, only:[:edit, :update]  
  before_action :set_shop_tags, only:[:show, :index, :edit, :update]

  def index
    @shop_configs = ShopConfig.own_shop_config(policy_scope(Shop))
  end

  def edit
    begin
      @shop_config = policy_scope(ShopConfig).find(params[:id])
      phone = Phonelib.parse(@shop_config.stock_notification_destination)
      @phone_country_code = phone.country_code || '62'
      @phone_national = phone.raw_national
    rescue => exception
      redirect_to '', flash: {danger: I18n.t('reject_access')}
    end
  end

  def update
    begin
      permited_params = params.require(:shop_config).permit(
        :hour, :min, :questionnaire_expiration_days,
        :front_priority_display,
        :customer_remind_interval_days, :use_customer_remind,
        :use_receipt, :receipt_layout, :receipt_open_expiration_days,
        :use_record_stock, :close_stock_time_hour, :close_stock_time_min,
        :phone_country_code, :phone_national, :use_stock_notification,
        payment_methods:[]
        )
      jakarta_time = DateTime.now.in_time_zone('Jakarta')
      message_send_time = jakarta_time.change(hour: permited_params[:hour].to_i, min: permited_params[:min].to_i)
      close_stock_time = jakarta_time.change(hour: permited_params[:close_stock_time_hour].to_i, min: permited_params[:close_stock_time_min].to_i)

      @phone_country_code = permited_params[:phone_country_code]
      @phone_national = permited_params[:phone_national]
      tel = permited_params[:phone_country_code] + permited_params[:phone_national] unless permited_params[:phone_national].empty?
      phone = Phonelib.parse(tel)
      tel = phone.international(false)

      @shop_config = policy_scope(ShopConfig).find(params[:id])
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
      payment_method_array = []
      permited_params[:payment_methods].each do |payment_method|
        payment_method_array << PaymentMethod.find(payment_method)
      end if permited_params[:payment_methods].present?
      @shop_config.shop.payment_methods = payment_method_array
      
      if @shop_config.save
        redirect_to admin_shop_configs_path
      else
        render :edit
      end
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
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
      @tags = @shop.shop_search_tags.is_using
    end

end
