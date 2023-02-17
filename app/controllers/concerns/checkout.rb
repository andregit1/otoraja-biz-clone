module Checkout
  extend ActiveSupport::Concern

  include Receipt

  included do
    helper_method :do_checkout
    helper_method :resend_receipt_sms
    helper_method :send_receipt_after_checkout
    helper_method :send_whatsapp_receipt
    helper_method :send_cost_estimation
  end

  def do_checkout(checkin, payment_method)

    maintenance_log = checkin.maintenance_log
    # 支払い方法登録
    # TODO 複数支払い方法を選択した場合の対応検討
    amount = maintenance_log.total_price || 0
    if maintenance_log.maintenance_log_payment_methods.present?
      # managerで更新された場合を想定
      maintenance_log.maintenance_log_payment_methods[0].update(
        payment_method: payment_method,
        amount: amount,
      )
    else
      maintenance_log.maintenance_log_payment_methods << MaintenanceLogPaymentMethod.new(
        payment_method: payment_method,
        amount: amount,
      )
      #gross profitを追加する
      get_gross_profit(maintenance_log)

      maintenance_log.save
    end

    # 購入履歴保存
    save_purchase_history(checkin)

    # チェックアウト時間記録
    checkin.checkout_datetime =  DateTime.now if checkin.checkout_datetime.nil?
    checkin.save

    # 在庫通知
    # stock_notification(checkin) if current_user.shops.first.shop_config.use_stock_notification
  end

  def send_receipt_after_checkout(checkin, send_sms, send_wa)
    # レシートSMS, WA送信
    send_sms = ActiveRecord::Type::Boolean.new.cast(send_sms)
    send_wa = ActiveRecord::Type::Boolean.new.cast(send_wa)

    # レシート発行
    if send_sms || send_wa
      output_receipt(checkin)
      receipt = new_receipt(checkin)
      receipt_questionnaire = new_receipt_questionnaire(checkin)
      send_receipt_sms(receipt) if send_sms && checkin.is_sendable_receipt_sms
      if send_wa && checkin.is_sendable_receipt_wa
        send_receipt_wa(receipt) 
        send_questionnaire_wa(receipt_questionnaire)
      end
    end
  end

  def send_whatsapp_receipt(checkin)
    receipt = new_receipt(checkin)
    send_receipt_wa(receipt) if checkin.is_sendable_receipt_wa
  end

  def resend_receipt_sms(checkin)
    token = Token.find_by(checkin: checkin, token_purpose: :receipt)
    begin
      if token.nil?
        send_receipt_sms(new_receipt(checkin))
      else
        send_receipt_sms(token)
      end
      "success"
    rescue => exception
      "#{exception.message}"
    end
  end

  def send_cost_estimation(checkin)
    expired_at = DateTime.now + checkin.shop.shop_config.receipt_open_expiration_days
    receipt = Token.create(uuid: Token.generate_uuid, expired_at: expired_at, token_purpose: :receipt)
    receipt.checkin = checkin

    send_cost_estimation_wa(receipt) if checkin.is_sendable_receipt_wa
  end

  def send_down_payment_with_receipt(checkin)
    expired_at = DateTime.now + checkin.shop.shop_config.receipt_open_expiration_days
    receipt = Token.create(uuid: Token.generate_uuid, expired_at: expired_at, token_purpose: :receipt)
    receipt.checkin = checkin

    send_down_payment_wa(receipt) if checkin.is_sendable_receipt_wa
  end

  private

  def new_receipt(checkin)
    # 有効期限設定
    expired_at = DateTime.now + checkin.shop.shop_config.receipt_open_expiration_days
    # Token生成
    token = Token.create_receipt_token(checkin, expired_at)
  end

  def new_receipt_questionnaire(checkin)
    shop_config = checkin.shop.shop_config
    expired_at = DateTime.now + shop_config.questionnaire_expiration_days
    token = Token.create_questionnaire_token(checkin, expired_at)
  end

  def send_receipt_sms(token)
    checkin = token.checkin
    # 短縮URL
    url = generate_short_url(token)
    # チェックアウト日時
    checkout_datetime = checkin.checkout_datetime.in_time_zone('Jakarta').strftime('%d-%b-%Y %H:%M:%S')
    # ショップ名
    shop_name = checkin.shop.name
    checkin_no = checkin.checkin_no
    date_today = ApplicationController.helpers.formatedCheckoutDate(checkin.checkout_datetime, 'Jakarta')
    maintenance_log = checkin.maintenance_log
    product = maintenance_log.maintenance_log_details.map{|m| m.name }.join("; ")
    total_price =  ApplicationController.helpers.formatedRupiahAmount(maintenance_log.total_price)
    
    # SMS送信
    body = I18n.t('message.sms_receipt_checkout', today: date_today, transaction_id: checkin_no, total_price: total_price, product: product, url: url, shop: shop_name)
    send_sms(token, checkin.customer.tel, body, :receipt)
    send_questionnaire_sms(token)
  end

  def send_receipt_wa(token)
    checkin = token.checkin
    maintenance_log = checkin.maintenance_log

    # 短縮URL & Other Attributes
    date_today = ApplicationController.helpers.formatedCheckoutDate(checkin.checkout_datetime, 'Jakarta')
    checkin_no = checkin.checkin_no
    total_price =  ApplicationController.helpers.formatedRupiahAmount(maintenance_log.total_price)
    product = maintenance_log.maintenance_log_details.map{|m| m.name }.join("; ")
    url = generate_short_url(token)
    shop_name = checkin.shop.name
    phone = checkin.shop.tel.present? ? Phonelib.parse(checkin.shop.tel).national(false) : 'Nomor telp tidak terdaftar'

    # Create an object to Use Whatsapp Utilities
    object = {
      from: shop_name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_receipt_new_v4]),
      params: [date_today, checkin_no, total_price, product, url, shop_name, shop_name, phone],
      to: checkin.customer.wa_tel,
      send_purpose: SendMessage.send_purposes["receipt"]
    }

    send_message = Whatsapp::WhatsappUtility.send_wa_notification(object)
    answer_choice_group = AnswerChoiceGroup.find_by(name: 'Default')
    Questionnaire.create(checkin: checkin, send_message: send_message, answer_choice_group: answer_choice_group)
    #if damcorp request status is 'invalid' there is a chance the customer
    #is not using WhatsApp so attempt to send an SMS
    #if 'bad response' then we should fallback to SMS
    send_receipt_sms(token) if [SendMessage.wa_send_statuses.key(5), SendMessage.wa_send_statuses.key(6)].include?(send_message.send_status)
    
  end

  def send_questionnaire_wa(token)
    checkin = token.checkin
    # 短縮URL
    url = generate_questionnaire_url(token)

    # Retrieve Attribute to Use Whatsapp Utilities
    object = {
      from: checkin.shop.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_questionnairre_new_v1]),
      params: [checkin.shop.name, url],
      to: checkin.customer.wa_tel,
      send_purpose: SendMessage.send_purposes["ty"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def get_whats_app_template(shop_id)
    whats_app_service = WhatsAppService.where(name: "Receipt").first
    shop_whats_app_template = ShopWhatsAppTemplate.where(shop_id: shop_id, whats_app_service_id: whats_app_service.id).first
    unless shop_whats_app_template.nil?
      #use shop specific tempate
      whats_app_template = WhatsAppTemplate.find(shop_whats_app_template.whats_app_template_id)
    else
      #get default template for service / environment
      whats_app_template = WhatsAppTemplate.get_template_by_id(whats_app_service.id)
    end
    return whats_app_template&.template_name
  end

  def generate_short_url(token)
    host = ENV['DOMAIN_NAME'] || 'localhost'
    url = "http://#{host}#{receipt_output_for_customer_path(token.uuid)}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def generate_questionnaire_url(token)
    host = ENV['DOMAIN_NAME'] || 'localhost'
    url = "https://#{host}#{questionnaire_path(token.uuid)}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def save_purchase_history(checkin)
    maintenance_log = checkin.maintenance_log
    customer = checkin.customer

    if maintenance_log.has_number_plate
      maintenance_log.maintenance_log_details.each do |detail|
        shop_product = detail.shop_product
        unless shop_product&.remind_interval_day.nil?
          product_category = shop_product.product_category
          if product_category.use_reminder
            purchase_history = if product_category.remind_grouping
              PurchaseHistory.joins(:shop_product).where(shop_products: {product_category: product_category}).find_or_initialize_by(
                customer: customer,
                number_plate_area: maintenance_log.number_plate_area,
                number_plate_number: maintenance_log.number_plate_number,
                number_plate_pref: maintenance_log.number_plate_pref
              )
            else
              PurchaseHistory.find_or_initialize_by(
                customer: customer,
                shop_product: shop_product,
                number_plate_area: maintenance_log.number_plate_area,
                number_plate_number: maintenance_log.number_plate_number,
                number_plate_pref: maintenance_log.number_plate_pref
              )
            end
            purchase_history.shop_product = shop_product
            purchase_history.maintenance_log_detail = detail
            purchase_history.last_purchase_date = Date.today
            purchase_history.reminded = false
            purchase_history.save
          end
        end
      end
    end
  end

  def get_gross_profit(maintenance_log)
    
    maintenance_log.maintenance_log_details.each do |detail|
      
      unit_price_average_record = FixedAveragePrice.where(shop_product_id: detail.shop_product_id).first() || StockControl.where(shop_product_id: detail.shop_product_id).where.not(average_price: nil).last();
     
      next if unit_price_average_record.nil? || unit_price_average_record.average_price.nil?

      detail.gross_profit = (detail.unit_price - unit_price_average_record.average_price) * detail.quantity

    end
  end

  def stock_notification(checkin)
    to = current_user.shops.first.shop_config.trim_stock_notification_destination
    return if to.nil?
    products = []
    checkin.maintenance_log.maintenance_log_details[0..(ShopProduct::PRODUCT_LIST_LIMIT - 1)].each do |detail|
      shop_product = detail.shop_product
      next if shop_product.nil?
      next unless shop_product.is_stock_control
      next if shop_product.stock_quantity.nil?
      next if shop_product.stock_minimum.nil?
      
      if shop_product.stock_minimum >= shop_product.stock_quantity
        # TODO: 文言決め
        products << shop_product
      end
    end
    return if products.empty?
    now = DateTime.now
    product_count = products.count
    products = products.map{ |product| [product.format_name, product.stock_quantity].join()}.join(", #{$/}")
    if product_count == ShopProduct::PRODUCT_LIST_LIMIT
      products += "#{$/} #{$/} #{ShopProduct.generate_low_shop_product_url}"
    end
    params = I18n.t('whatsapp.text.short_product', shop_name: checkin.shop.name, line_break: $/)+products
    data = {
      "to"=>[to],
      "message"=>params
    }
    response = Whatsapp::WhatsappUtility.send_text(data)
    response_data = response["data"].first unless response["data"].nil?
    send_message = SendMessage.create(
      to: to, 
      body: Whatsapp::SEND_TEXT_ENDPOINT, 
      send_type: :wa, 
      send_purpose: :daily_stock_notification, 
      send_datetime: now, 
      sent_at: now, 
      message_id: response_data["msgId"], 
      send_status: response_data["status"],
      resend_attempts: 0,
      parameters: params
    )
  end

  def send_questionnaire_sms(token)
    checkin = token.checkin
    url = generate_questionnaire_url(token)
    body = I18n.t('message.sms_questionairre', shop: checkin.shop.name, url: url)
    send_message = SendMessage.create(to: checkin.customer.tel, body: body, send_type: :sms, send_purpose: :ty, send_datetime: DateTime.now)
    send_sms(token, checkin.customer.tel, body, :ty)
  end 

  def send_sms(token, to, body, purpose) 
    send_message = SendMessage.create(to: to, body: body, send_type: :sms, send_purpose: purpose, send_datetime: DateTime.now)
    client = Aws::AwsUtility.SNS_client
    resp = client.publish({
      phone_number: send_message.to,
      message: send_message.body,
      message_attributes: {
        'AWS.SNS.SMS.SMSType' => {
          data_type: 'String',
          string_value: 'Transactional'
        }
      }
    })
    send_message.update(sent_at: DateTime.now, message_id: resp.message_id)
  end

  def generate_cost_estimation_url(token)
    host = ENV['DOMAIN_NAME'] || 'localhost'
    url = "http://#{host}#{receipt_output_cost_estimation_for_customer_path(token.uuid)}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def generate_down_payment_url(token)
    host = ENV['DOMAIN_NAME'] || 'localhost'
    scheme = host == 'localhost' ? 'http' : 'https'
    url = "#{scheme}://#{host}#{receipt_output_down_payment_for_customer_path(token.uuid)}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def send_cost_estimation_wa(token)
    checkin = token.checkin
    maintenance_log = checkin.maintenance_log
    date_today = ApplicationController.helpers.formatedCheckoutDate(DateTime.now, 'Jakarta')
    total_price =  ApplicationController.helpers.formatedRupiahAmount(maintenance_log.total_price)
    output_receipt_not_paid(token, :cost)
    url = generate_cost_estimation_url(token)
    shop_name = checkin.shop.name

    object = {
      from: shop_name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_cost_estimation_v3]),
      params: [shop_name, date_today, total_price, url],
      to: checkin.customer.wa_tel,
      send_purpose: SendMessage.send_purposes["cost_estimation"]
    }

    send_message = Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def send_down_payment_wa(token)
    checkin = token.checkin
    maintenance_log = checkin.maintenance_log
    date_today = ApplicationController.helpers.formatedCheckoutDate(DateTime.now, 'Jakarta')
    total_amount = maintenance_log.total_down_payment_amount
    output_receipt_not_paid(token, :down_payment)
    url = generate_down_payment_url(token)
    object = {
      from: checkin.shop.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_down_payment_receipt_v1]),
      params: [date_today, checkin.checkin_no, "#{maintenance_log.total_price}", "#{total_amount}", url],
      to: checkin.customer.tel,
      send_purpose: SendMessage.send_purposes["receipt"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end
end
