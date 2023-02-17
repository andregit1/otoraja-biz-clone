class Front::CustomersController < Front::ApiController
  protect_from_forgery :except => [:parse_phone_number, :send_confirm_sms]
  include AwsSns
  include CheckIn

  def suggest
    @customers = Customer.es_search_byfield(params[:name], params[:tel], params[:number_plate], current_user.shops.ids).records
  end

  def find
    if params[:id].present?
      @customer = policy_scope(Customer).find(params[:id])
    else
      if params[:phone_country_code].present? && params[:phone_national].present?
        tel = Phonelib.parse("#{params[:phone_country_code]}#{params[:phone_national]}")
        @customer = policy_scope(Customer).find_by(tel: tel.international(false))
      else
        owned_bike = OwnedBike.find_by(
          number_plate_area: params[:number_plate_area],
          number_plate_number: params[:number_plate_number],
          number_plate_pref: params[:number_plate_pref]&.upcase
        )
        @customer = policy_scope(Customer).find_by(id: owned_bike.customer_id) if owned_bike.present?
      end
    end

    unless @customer.present? 
      response_no_content
    end
  end

  def term
    @term = Term.where('effective_date <= ?', DateTime.now).where(terms_purpose: :to_bengkel).order(effective_date: :desc).first
  end

  def parse_phone_number
    render :json => parse_tel(params[:tel])
  end

  def send_confirm_sms
    result = parse_tel(params[:tel])
    if result[:valid]
      shop = current_user.shops.first
      send_sms(result[:tel_international], I18n.t('sms.regist_message', shop: shop.name))
      send_wa_notification(result[:tel_international])
    end
    render :json => result
  end

  def histories
    @customer = Customer.find_by(id: params[:customer_id])
    @histories = if params[:maintenance_log_id].nil?
      policy_scope(MaintenanceLog).get_histories_by_customer_id(params[:customer_id]).limit(10)
    else
      policy_scope(MaintenanceLog).get_histories_by_customer_id(params[:customer_id], params[:maintenance_log_id]).limit(10)
    end
  end

  # deprecated
  # Can be used up to Android App version 1.10.0
  # As of 1.11.0, replaced by checkins_controller#search_list
  def search_checkin
    customers = Customer.es_search(params[:search_word], current_user.shops.ids).records
    @all_checkins = policy_scope(Checkin).where(customer_id: customers.ids).order(datetime: :desc)
    @uncheckout_checkins = policy_scope(Checkin).where(customer_id: customers.ids).where(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
    @checkout_checkins = policy_scope(Checkin).where(customer_id: customers.ids).where.not(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
    render 'checkin'
  end

  def check_phone_number
    begin
      new_phone = Phonelib.parse(params[:tmp_tel])

      return render json: { message: I18n.t("admin.customer.phone_number_invalid"), success: false, error: 1 } if new_phone.invalid?

      new_phone = new_phone.sanitized

      customer = Customer.find(params[:id])
      is_used = Customer.find_by_tel(new_phone)

      if customer.tel == new_phone
        render json: { message: "Nomor yang dimasukan sama dengan yang sekarang.", success: false, error: 1 } 
      elsif is_used
        render json: { message: "Nomer sudah ada di sistem. Gunakan nomor lain", success: false, error: 2 } 
      else
        render json: { message: "Berhasil", success: true, error: 0 } 
      end
    rescue => exception
      render json: {message: I18n.t('reject_access'), success: false }
    end
  end

  def update_basic_info
    begin
      customer = Customer.find_by_id(params[:customer][:id])
      customer.update(tmp_tel: Phonelib.parse(params[:customer][:tmp_tel]).sanitized, token_request_count: 0, token_locked_at: nil)
      if(params[:customer][:tmp_tel].present?)
        time_zone_now = DateTime.now.in_time_zone('Jakarta')
        token_request_count = customer.token_request_count + 1 

        customer.update(token_request_count: 1)
        send_change_phone_number_wa(customer)

        render json: {
          countdown: countdown, 
          token_request_count: customer.token_request_count, 
          token_locked_at: customer.token_locked_at,
          tmp_tel: customer.tmp_tel
        }
      end
    rescue => e
      puts e
    end
  end

  def request_token
    customer_id = params.has_key?(:customer_id) ? params[:customer_id] : params[:customer][:id]
    customer = Customer.find_by_id(customer_id)
    time_zone_now = DateTime.now.in_time_zone('Jakarta')
    token_request_count = customer.token_request_count + 1 
    if customer.token_locked_at.present?
      if (time_zone_now - customer.token_locked_at) < locked_time
        render json: {
          message: I18n.t('admin.customer.request_token_locked_message'), 
          locked_time: (time_zone_now + locked_time).strftime("%H:%M"), 
          token_request_count: customer.token_request_count, 
          locked_until: (time_zone_now + locked_time).strftime("%H:%m"),
          tmp_tel: customer.tmp_tel
        }
        return
      else
        customer.update_columns(token_request_count: 1, token_locked_at: nil)
        render json: {
          countdown: countdown, 
          token_request_count: customer.token_request_count, 
          token_locked_at: customer.token_locked_at,
          tmp_tel: customer.tmp_tel
        }
        send_change_phone_number_wa(customer)
        return
      end
    end   

    if customer.token_request_count >= max_token_request && customer.token_locked_at.blank?
      customer.update_columns(token_locked_at: time_zone_now)
      render json: {
        message: I18n.t('admin.customer.request_token_locked_message', 
          locked_time: (time_zone_now + locked_time).strftime("%H:%M")), 
          token_request_count: customer.token_request_count, 
          locked_until: (time_zone_now + locked_time).strftime("%H:%m"),
          tmp_tel: customer.tmp_tel
        }
      return
    end

    customer.update(token_request_count: token_request_count)
    send_change_phone_number_wa(customer)

    render json: {
      countdown: countdown, 
      token_request_count: customer.token_request_count, 
      token_locked_at: customer.token_locked_at,
      tmp_tel: customer.tmp_tel
    }
  end

  def remove_tmp_tel
    begin
      customer = Customer.find_by_id(params[:customer][:id])
      customer.update(tmp_tel: nil, token_request_count: 0, token_locked_at: nil)
    
      render json: { message: "Berhasil", success: true, status: 200 }  
    rescue => exception
      render json: {message: I18n.t('reject_access'), success: false, status: 500 }
    end
  end

  # deprecated
  # Can be used up to Android App version 1.10.0
  # As of 1.11.0, replaced by checkins_controller#list
  def checkin
    # WIB(ジャカルタ時間)取得
    now = DateTime.now.in_time_zone('Jakarta')
    @today = Date.new(now.year, now.month, now.day)
    if params[:checkin_day].present?
      @checkin_day = Date.parse(params[:checkin_day])
    else
      @checkin_day = @today
    end
    # DB上はUTCで管理しているため、変換する
    tz_today = DateTime.parse("#{@today.year}-#{@today.month}-#{@today.day} 00:00:00 +0700")
    tz_checkin_day = DateTime.parse("#{@checkin_day.year}-#{@checkin_day.month}-#{@checkin_day.day} 00:00:00 +0700")
    checkin_from = tz_checkin_day.in_time_zone('UTC')
    checkin_to = (tz_checkin_day.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')

    @all_checkins = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).order(datetime: :desc)
    @uncheckout_checkins = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).where(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
    @checkout_checkins = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).where.not(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
  end

  def update
    ActiveRecord::Base.transaction do
      begin
        customer_params = params[:customer]
        customer = Customer.find_by(id: customer_params[:id])
        exisiting_customer = Customer.find_by(tel: customer_params[:tel])
        if exisiting_customer.present?
          #if customer is present then we need to check the owned bikes
          #of the customer passed into the method. if they have a bike that is 
          #different than the owned bikes of the exisiting customer then we
          #need to change the association
          #this will occur if a customer registers a bike but has not added a tel number
          maintenance_log = policy_scope(MaintenanceLog).find_by(id:params[:id])
          if maintenance_log.has_number_plate
            exisiting_customer_bikes = exisiting_customer.owned_bikes
            has_bike = exisiting_customer_bikes.find_by(
              number_plate_area: maintenance_log.number_plate_area, 
              number_plate_number: maintenance_log.number_plate_number, 
              number_plate_pref: maintenance_log.number_plate_pref
            ).present?
            unless has_bike?
              customer_bike = customer.owned_bikes.find_by(
                number_plate_area: maintenance_log.number_plate_area, 
                number_plate_number: maintenance_log.number_plate_number, 
                number_plate_pref: maintenance_log.number_plate_pref
              )
              customer_bike.update!(
                customer_id: exisiting_customer.id
              )
            end
          end
          maintenance_log.checkin.update!(
            customer_id: exisiting_customer.id
          )
        else
          customer.update!(
            tel: customer_params[:tel],
            wa_tel: customer_params[:wa_tel],
            name: customer_params[:name],
            send_dm: customer_params[:send_dm],
            send_type: Customer.send_types[:sms_wa],
            terms_agreed_at: DateTime.now,
          )
        end
        render json: customer
      rescue => e 
        logger.error(e.message)
      end
    end
  end

private
  def send_change_phone_number_wa(customer)
    object = {
      from: customer.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_change_phone_number_v1]),
      params: [customer.name, generate_phone_number_confirmation_url(customer)],
      to: customer.tmp_tel,
      send_purpose: SendMessage.send_purposes["change_phone_number"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def generate_phone_number_confirmation_url(customer)
    expired_at = DateTime.now.in_time_zone('Jakarta') + 3.hours
    token = Token.create_change_phone_number_token(customer, expired_at)
    host = ENV.fetch('DOMAIN_NAME', "localhost")
    url = "https://#{host}#{change_phone_number_verification_path(token.uuid)}"

    return Otoraja::ShortUrl.generate_short_url(url)
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
  
  def parse_tel(tel)
    phone = Phonelib.parse(tel)
    if phone.valid?
      status = {
        status:'valid',
        valid: true,
        tel_org: tel,
        tel_international: phone.international(false),
        tel_formated_international: phone.international(),
        tel_national: phone.national(false),
        tel_formated_national: phone.national(),
        country_code: phone.country_code(),
      }
    else
      status = {
        status:'invalid',
        valid: false,
        tel_org: tel,
      }
    end
    return status
  end
end
