class Api::CustomersController < Api::ApiController
  skip_before_action :verify_authenticity_token, only:[:valid_phone_number, :valid_numberplate]

  def suggest
    @customers = Customer.es_search(search_word, current_user.shops.ids).records
  end

  def suggest_byfield
    @customers = Customer.es_search_byfield(params[:name], params[:tel], params[:number_plate], current_user.shops.ids).records
    render 'suggest'
  end

  def valid_phone_number
    phone_country_code = params[:phone_country_code]
    phone_national = params[:phone_national]
    tel = phone_country_code + phone_national
    err_msg = ''

    # 電話番号未入力チェック
    if phone_national.blank?
      err_msg = t('warning.phone.required')
      render json: {valid: err_msg.blank?, err_msg: err_msg}
      return
    end

    # 妥当性チェック
    phone = Phonelib.parse(tel)
    unless phone.valid?
      err_msg = t('warning.phone.invalid')
      render json: {valid: err_msg.blank?, err_msg: err_msg}
      return
    end

    render json: {valid: err_msg.blank?, err_msg: err_msg, tel: phone.international(false)}
  end

  def valid_numberplate
    number_plate_area = params[:number_plate_area]
    number_plate_number = params[:number_plate_number]
    number_plate_pref = params[:number_plate_pref].upcase
    err_msg = ''

    # 未入力チェック
    unless number_plate_area.present? && number_plate_number.present? && number_plate_pref.present?
      err_msg = 'Number plate required'
    end

    render json: {valid: err_msg.blank?, err_msg: err_msg}
  end

  def owned_bikes
    customer = Customer.find(params[:id])
    @owned_bikes = customer.owned_bikes.order(created_at: :desc)
  end

  def histories
    @customer = Customer.find_by(id: params[:customer_id])
    @readonly = params[:readonly]
    if params[:maintenance_log_id].nil?
      @histories = policy_scope(MaintenanceLog).get_histories_by_customer_id(params[:customer_id]).limit(10)
    else
      @histories = policy_scope(MaintenanceLog).get_histories_by_customer_id(params[:customer_id],params[:maintenance_log_id]).limit(10)
    end
  end

  def search_checkin
    customers = Customer.es_search(search_word, current_user.shops.ids).records
    @all_checkins = policy_scope(Checkin).where(customer_id: customers.ids).order(datetime: :desc)
    @uncheckout_checkins = policy_scope(Checkin).where(customer_id: customers.ids).where(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
    @checkout_checkins = policy_scope(Checkin).where(customer_id: customers.ids).where.not(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)
    render 'checkin'
  end

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

  def find
    phone_country_code = params[:phone_country_code]
    phone_national = params[:phone_national]
    phone_number = phone_country_code + phone_national
    tel = Phonelib.parse(phone_number)

    @customer = Customer.find_by(tel: tel.international(false))

    if @customer.present? && params[:number_plate_area].present? && params[:number_plate_number].present? && params[:number_plate_pref].present?
      @owned_bike = @customer.owned_bikes.find_by(
        number_plate_area: params[:number_plate_area],
        number_plate_number: params[:number_plate_number],
        number_plate_pref: params[:number_plate_pref].upcase
      )
    end
  end

private
  def search_word
    @search_word ||= params[:search_word]
  end
end
