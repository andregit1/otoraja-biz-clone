class Admin::CustomersController < Admin::ApplicationAdminController
  # before_action :check_admin_authority, only:[:edit, :update, :export]

  def list
    begin
      if params[:q].present?
        order = params[:sort] || 'last_visit_datetime desc' 
        order = params[:q][:s] if params[:q][:s].present?
        params[:q][:owned_bikes_full_plate_number_cont] = params[:q][:owned_bikes_full_plate_number_cont].
          delete(" ") if params[:q][:owned_bikes_full_plate_number_cont].present? 
        params[:q][:tel_cont] = params[:q][:tel_cont][1..-1].
          delete(" ") if params[:q][:tel_cont].present? && params[:q][:tel_cont].chars.first == '0'
      end
    
      @q = policy_scope(Customer).left_joins(:owned_bikes).joins(:checkins).where('checkins.shop_id': session[:default_user_shop]).group('checkins.customer_id').select('customers.*, max(datetime) as last_visit_datetime').ransack(params[:q])
      @customers = @q.result.page(params[:page]).per(10)
      @customers = @customers.where.not('customers.name': ['', nil]).or(@customers.where.not('customers.tel': ['', nil])).or(@customers.where.not('owned_bikes.number_plate_number': ['', nil]))
      @customers = @customers.order(order)
      @search_field = { 'Nama': 'q_name_cont', 'No Telp': 'q_tel_cont', 'Plat No': 'q_owned_bikes_full_plate_number_cont' }
      @select_search_field = params[:select_search_field] || 'q_name_cont'
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def show
    @locked_time = locked_time
    @max_token_request = max_token_request
    begin
      @customer = policy_scope(Customer).find_by_id(params[:id])
      if @customer.token_locked_at.present? && (DateTime.now.in_time_zone('Jakarta') - @customer.token_locked_at) > locked_time
        @customer.update_columns(token_request_count: 0, token_locked_at: nil)
      end
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access')}
    end
  end

  def checkin
    begin
      @maintenance_log = policy_scope(MaintenanceLog).find(params[:maintenance_log_id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def maintenance_logs
    begin
      @maintenance_logs = policy_scope(MaintenanceLog)
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def checkins
    begin
      @checkins = policy_scope(Checkin).includes(:customer).where(shop_id: session[:default_user_shop]).where('customers.id': params[:id]).exclude_system_created.page(params[:page]).per(10)
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access')}
    end
  end

  def owned_bikes

  end

  def edit
    begin
      @customer = policy_scope(Customer).find_by_id(params[:id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def edit_basic_info
    begin
      @customer = policy_scope(Customer).find_by_id(params[:id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def update
    begin
      customer = policy_scope(Customer).find_by_id(params[:id])
      customer.update(send_dm: params[:customer][:send_dm])
      redirect_to admin_customer_show_path
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def update_basic_info
    begin
      customer = policy_scope(Customer).find_by_id(params[:id])
      customer.update(name: params[:customer][:name], tmp_tel: Phonelib.parse(params[:customer][:tmp_tel]).sanitized, token_request_count: 0, token_locked_at: nil)
      if(params[:customer][:tmp_tel].present?)
        time_zone_now = DateTime.now.in_time_zone('Jakarta')
        token_request_count = customer.token_request_count + 1 

        customer.update(token_request_count: 1)
        send_change_phone_number_wa
      end
      redirect_to admin_customer_show_path
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access')}
    end
  end

  def answers
    begin
      @customer_id = params[:id]
      @answers = policy_scope(Answer).joins({questionnaire: :checkin}).where(checkins: {customer_id: params[:id], shop_id: session[:default_user_shop]}).includes(questionnaire: {checkin: :shop}).page(params[:page]).per(10)
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def export
    respond_to do |format|
      format.csv {
        customers_csv = policy_scope(Customer).generate_csv(current_user)
        send_data customers_csv, filename: "customers_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      }
    end
  end

  def check_phone_number
    begin
      new_phone = Phonelib.parse(params[:tmp_tel])

      return render json: { message: I18n.t("admin.customer.phone_number_invalid"), success: false, error: 1 } if new_phone.invalid?

      new_phone = new_phone.sanitized

      customer = Customer.find(params[:id])
      is_used = Customer.find_by_tel(new_phone)

      if customer.tel == new_phone
        render json: { message: I18n.t("admin.customer.phone_number_is_same"), success: false, error: 1 } 
      elsif is_used
        render json: { message: I18n.t("admin.customer.phone_number_is_used"), success: false, error: 2 } 
      else
        render json: { success: true } 
      end
    rescue => exception
      render json: {message: I18n.t('reject_access'), success: false }
    end
  end

  def remove_tmp_tel
    customer.update(tmp_tel: nil, token_request_count: 0, token_locked_at: nil)
  
    head 201  
  end

  def request_token
    time_zone_now = DateTime.now.in_time_zone('Jakarta')
    token_request_count = customer.token_request_count + 1 

    if customer.token_locked_at.present?
      if (time_zone_now - customer.token_locked_at) < locked_time
        render json: {message: I18n.t('admin.customer.request_token_locked_message', locked_time: (time_zone_now + locked_time).strftime("%H:%M")), token_request_count: customer.token_request_count, locked_until: (time_zone_now + locked_time).strftime("%H:%m")}
        return
      else
        customer.update_columns(token_request_count: 1, token_locked_at: nil)
        render json: {countdown: COUNT_DOWN, token_request_count: customer.token_request_count, token_locked_at: customer.token_locked_at}
        send_change_phone_number_wa
        return
      end
    end   

    if customer.token_request_count >= max_token_request && customer.token_locked_at.blank?
      customer.update_columns(token_locked_at: time_zone_now)
      render json: {message: I18n.t('admin.customer.request_token_locked_message', locked_time: (time_zone_now + locked_time).strftime("%H:%M")), token_request_count: customer.token_request_count, locked_until: (time_zone_now + locked_time).strftime("%H:%m")}
      return
    end

    customer.update(token_request_count: token_request_count)
    send_change_phone_number_wa

    render json: {countdown: countdown, token_request_count: customer.token_request_count, token_locked_at: customer.token_locked_at}
  end

  private 

  def send_change_phone_number_wa
    object = {
      from: customer.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_change_phone_number_v1]),
      params: [customer.name, generate_phone_number_confirmation_url],
      to: customer.tmp_tel,
      send_purpose: SendMessage.send_purposes["change_phone_number"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def generate_phone_number_confirmation_url
    host = ENV.fetch('DOMAIN_NAME', "localhost")
    url = "https://#{host}#{change_phone_number_verification_path(token.uuid)}"

    Otoraja::ShortUrl.generate_short_url(url)
  end

  def token
    expired_at = DateTime.now.in_time_zone('Jakarta') + 3.hours
    @token ||= Token.create_change_phone_number_token(customer, expired_at)
  end

  def customer 
    begin
      @customer ||= Customer.find_by_id(params[:id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def max_token_request
    3
  end

  def locked_time
    1.hour
  end

  def countdown
    120
  end
end