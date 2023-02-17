module ApplicationHelper

  include ActionView::Helpers::NumberHelper

  def formatedDate(date)
    date&.strftime('%d-%b-%Y')
  end

  def formattedDatelocal(date, tz)
    date.to_datetime&.in_time_zone(tz)&.strftime("%Y-%m-%dT%H:%M:%S")
  end

  def formattedDateTimePicker(date)
    date.to_datetime&.strftime("%Y-%m-%dT%H:%M:%S")
  end
  
  def formatedDateTz(date, tz)
    date&.in_time_zone(tz)&.strftime('%d-%m-%Y')
  end

  def formatedTime(datetime, tz)
    datetime.in_time_zone(tz).strftime('%H:%M')
  end

  def formatedTimestamp(datetime, tz)
    datetime.in_time_zone(tz).strftime('%H:%M:%S')
  end

  def formatedDateTime(datetime, tz, with_timezone = true)
    if with_timezone
      datetime&.in_time_zone(tz)&.strftime('%d-%m-%Y %H:%M:%S %Z')
    else
      datetime&.in_time_zone(tz)&.strftime('%d-%m-%Y %H:%M:%S')
    end
  end

  def formatedCheckinDateTime(datetime, tz)
    datetime.in_time_zone(tz).strftime('%d.%m.%Y / %H:%M')
  end

  def formatedCheckinDate(date)
    date.strftime('%d.%m.%Y')
  end

  def formatedCheckinDateTz(datetime, tz)
    datetime.in_time_zone(tz).strftime('%d.%m.%Y')
  end

  def formatedCheckoutDate(datetime, tz)
    I18n.l(datetime&.in_time_zone(tz), format: "%A, %d %B %Y %T %Z")
  end

  def formatedRupiahAmount(amount)
    number_to_currency(amount, delimiter: ".", precision: 0, unit: "Rp.")
  end

  def formatedAmount(amount)
    number_to_currency(amount, delimiter: ".", precision: 0, unit: "")
  end

  def formatedDateUseSpace(date)
    date.strftime('%d %B %Y')
  end

  def formatedDateUseSlash(date)
    date.strftime('%d/%m/%Y')
  end

  def formatedDateUseDot(date)
    date.strftime('%d.%m.%Y')
  end
  
  def formatedDateUseDash(date)
    date.strftime('%d-%m-%Y')
  end

  def formatedMonthSpace(date)
    I18n.l(date, format: '%d %B %Y')
  end

  def diffDate(from, to)
    (from.to_date - to.to_date).to_i
  end

  def formatedPhoneNumber(number, international = true)
    if international
      Phonelib.parse(number).international
    else
      Phonelib.parse(number).national
    end
  end

  def sanitizePhoneNumber(number)
    number = Phonelib.parse(number).sanitized
    if number.first(2) == '08'
      number['0'] = '62'
      number
    elsif  number.first(1) == '8'
      '62' + number
    else
      number
    end
  end

  def formatedNumberPlate(object)
    unless object.nil?
      area = object.number_plate_area || ''
      number = object.number_plate_number || ''
      pref = object.number_plate_pref || ''

      "#{area} #{number} #{pref}"
    end
  end

  def formatedExpirationDate(object)
    unless object.nil?
      month = object.expiration_month || ''
      year = object.expiration_year || ''
      unless "#{month}#{year}" == ""
        "#{month}/#{year}"
      end
    end
  end

  def formatedCheckinInfo(object)
    info = []
    
    if object.customer.name.present?
      info << object.customer.name
    elsif object.maintenance_log.present? && object.maintenance_log.name.present? 
      info << object.maintenance_log.name 
    end
    info << formatedPhoneNumber(object.customer.tel) if object.customer.tel.present?
    info << formatedNumberPlate(object.maintenance_log) if object.maintenance_log.present?
    if object.maintenance_log.present? && object.maintenance_log.color.present? 
      info << object.maintenance_log.color
    end
    info.join('<br>')
  end

  def formatedTooltipForMaintenanceLog(object)
    info = []
    info << object.name if object.name.present?
    info << object.model if object.model.present?
    info << object.color if object.color.present?
    info << formatedNumberPlate(object)
    info.join('<br>')
  end

  def formatedBikeInfo(object)
    info = []
    bike = []
    bike << object.maker if object.maker.present?
    bike << object.model if object.model.present?
    info << bike.join(' / ') if bike.present?
    info << object.color if object.color.present?
    info.join(' / ')
  end

  def formatedTimeHour(datetime, tz)
    datetime.in_time_zone(tz).hour.to_s.rjust(2, '0')
  end

  def hoursArray()
    array = [*0..23].map(&:to_s)
    array.map {|hour| hour.rjust(2, '0')}
  end

  def minsArray(minute_step)
    array = 0.step(59, minute_step).map(&:to_s)
    array.map {|min| min.rjust(2, '0')}
  end

  def release_note_path
    filename = 'release_note.html'
    if Rails.env.production? || Rails.env.staging? || Rails.env.design?
      "https:#{App::Application.config.action_controller.asset_host}/#{filename}"
    else
      "/#{filename}"
    end
  end

  # 集計単位選択肢用
  def aggregationUnitArray()
    ['Harian', 'Mingguan', 'Bulanan']
  end

  # daterangepickerの初期日付範囲
  def drpInitialRange()
    (Date.today - 7).strftime('%-d/%-m/%Y') + ' - ' + (Date.today - 1).strftime('%-d/%-m/%Y')
  end

  def drpInitialStartDate()
    (Date.today).strftime('%Y-%m-%d 00:00:00')
  end

  def drpInitialEndDate()
    (Date.today).strftime('%Y-%m-%d 23:59:59')
  end

  # 小数点四捨五入&3桁区切り
  def formatedRupiah(value)
    "#{value.round.to_s(:delimited, delimiter: '.')}"
  end

  # 数値3桁区切り(ピリオド)小数点(カンマ)
  def formatedDecimalPoint(value)
    "#{value.to_s(:delimited, delimiter: '.', separator: ',')}" unless value.nil?
  end

  def current_staff
    ShopStaff.find(session[:current_staff_id]) if session[:current_staff_id]
  end

  def priority_display_header
    config = current_user.shops.first.shop_config
    config.front_priority_display
  end

  def priority_display_body(checkin)
    config = current_user.shops.first.shop_config
    if config.front_priority_display_number_plate?
      formatedNumberPlate(checkin.maintenance_log) if checkin.maintenance_log.present?
    elsif config.front_priority_display_phone_number?
      formatedPhoneNumber(checkin.customer.tel, false) if checkin.customer.tel.present?
    elsif config.front_priority_display_customer_name?
      if checkin.customer.name.present?
        checkin.customer.name
      elsif checkin.maintenance_log.present? && checkin.maintenance_log.name.present? 
        checkin.maintenance_log.name 
      end
    end
  end

  def convert_invalid_characters(value)
    value&.gsub(/[^.,0-9a-z]/,'%')
  end

  def matched_bike(owned_bike, maintenance_log)
    o = []
    m = []
    o << owned_bike.number_plate_area.to_s
    o << owned_bike.number_plate_number.to_s
    o << owned_bike.number_plate_pref.to_s
    o << owned_bike.expiration_month.to_s
    o << owned_bike.expiration_year.to_s
    m << maintenance_log.number_plate_area.to_s
    m << maintenance_log.number_plate_number.to_s
    m << maintenance_log.number_plate_pref.to_s
    m << maintenance_log.expiration_month.to_s
    m << maintenance_log.expiration_year.to_s
    unless owned_bike.bike.nil?
      o << owned_bike.bike.maker.to_s
      o << owned_bike.bike.model.to_s
      o << owned_bike.bike.color.to_s
      m << maintenance_log.maker.to_s
      m << maintenance_log.model.to_s
      m << maintenance_log.color.to_s
    end
    o.join('|') == m.join('|')
  end

  def table_sort_link(target, text)
    order = (params[:sort].present? && params[:sort].include?(target) && params[:sort].include?('asc')) ? 'desc' : 'asc'
    link_to text, 'javascript:void(0)', class: 'sort-link table-sort-link', data: {colmun: target, order: order}
  end

  def get_profit_chart_data(source, key)
    arr = []
    #list of labels(dates) containing lists of products sold that date
    source.each do | k, v |
      added = false
      #if we find a list, check if any product names match our current dataset key
      #zeros in the array represent no data
      #outcome: either 0 or list of products
      unless v == 0
        v.each do | item |
          if item[:name] == key
            added = true;
            arr.push(item[:value])
          end
        end
        #if we didnt find any, we need to add a zero record
        unless added
          arr.push(0)
        end
      else
        arr.push(v)
      end
    end
    arr
  end

  def get_current_shop_session(session, current_user)
    shop = current_user.managed_shops_without_suspended.first
    unless session[:default_user_shop].present?
      session[:default_user_shop] = shop.id
      session[:expiration_date] = shop.expiration_date.present? ? formatedDateUseDash(shop.expiration_date) : 'dd-mm-yyyy'
    end
  end

  def convert_to_weekdays(date)
    if date.saturday?
      date + 2
    elsif date.sunday?
      date + 1
    else
      date
    end
  end

  def payment_logo_path(filename)
    if Rails.env.production? || Rails.env.staging? || Rails.env.design?
      "https:#{App::Application.config.action_controller.asset_host}/#{filename}"
    else
      "https://otoraja-biz-staging-assets-sg.s3.ap-southeast-1.amazonaws.com/#{filename}"
    end
  end
end
