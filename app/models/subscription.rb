class Subscription < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  belongs_to :shop, optional: true
  belongs_to :shop_group
  belongs_to :va_code_area, optional: true
  belongs_to :payment_type, optional: true

  has_many :transaction_logs
  
  enum plan: {
    no_plan: 0,
    lite: 1, 
    super: 2, 
    ultimate: 3,
    _Testing_payment_gateway_: 4
  }

  enum status: {
    processing: 0,
    creating_bank_account: 1,
    payment_pending: 2,
    payment_confirmed: 3,
    finalized: 4,
    cancelled: 5,
    expire: 6,
    demo_period: 7,
    extension_period: 8,
    payment_gateway_expired: 9,
    payment_gateway_renewal: 10
  }
  
  enum period: {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    ten: 10,
    eleven: 11,
    twelve: 12,
  }

  enum status_subs: {
		suspend: 0,
		demo: 1,
		paid: 2
	  }

  has_one_attached :receipt
  has_one_attached :payment_receipt

  scope :own_shop, ->(shop_ids) {
    joins(:shop).where(shops: { id: shop_ids } )
  }

  scope :list_with_shop, -> {
    joins(:shop).where.not(status: [:extension_period, :demo_period])
  }

  scope :shop_plan_subscription, -> {
    where(status: :finalized).or(self.where(status: :expire)).or(self.where(status: :demo_period))
  }

  scope :list_plan_subscription, ->(shop_id){
    where(status: :finalized).or(self.where(status: :expire).or(self.where(status: :demo_period))).where(shop_id: shop_id)
  }

  scope :extension_history, -> {
    where(status: :extension_period)
  }

  scope :extension_history_each_shop, ->(shop_id){
    where(status: :extension_period).where(shop_id: shop_id)
  }
  
  scope :get_shop_group, ->(){
    eager_load(:shop_group)
  }

  def send_processing_notification
    #template params 
    # 1 = shop_name 
    # 2 = subscription_plan_name
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_application_received])
    plan = self.plan_i18n
    params = [self.shop.name, plan]
    subscription = Subscription.find(self.id)

    #send to shop if send info is available
    subject = I18n.t('subscription.email.subject.application_processing',id: subscription.order_ids) 
    body = I18n.t('subscription.email.body.application_processing', shop_name: self.shop.name, id: subscription.order_ids, date: date_with_timezone(self.created_at), plan: plan)
    send_wa_notification(template.template_name, params) if can_send_wa(template, params)
    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def send_creating_bank_account_notification
    #params
    # 1 = Bengkel shop name
    # 2 =  Subscription plan name
    # 3 = Amount to pay
    # 4 = Virtual account number
    # 5 = Due date
    plan = self.plan_i18n
    params = [self.shop.name, plan, self.fee.to_s, self.shop.virtual_bank_no, Date.today + ENV['PAYMENT_PERIOD'].to_i]
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_bank_account_created])
    subject = I18n.t('subscription.email.subject.bank_account_created',id: self.id) 
    body = I18n.t('subscription.email.body.bank_account_created', shop_name: self.shop.name, plan: plan, fee: self.fee, bank_no: self.shop.virtual_bank_no)
    send_wa_notification(template.template_name, params) if can_send_wa(template, params)
    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def send_payment_instruction_notification(payment_method)
    plan = self.plan_i18n
    subscription = Subscription.find(self.id)
    subject = I18n.t('subscription.email.subject.bank_account_created',id: subscription.order_ids) 
    template = "subscription.email.body.#{payment_method}_instruction"
    body = I18n.t(template, shop_name: self.shop.name, plan: plan, fee: self.fee)

    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def send_payment_received_notification
    #params 
    # 1 = shop_name 
    # 2 = subscription_plan_name
    plan = self.plan_i18n
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_subscription_payment_received])
    params = [self.shop.name, plan]
    subject = I18n.t('subscription.email.subject.payment_received',id: self.id)
    body = I18n.t('subscription.email.body.payment_received', shop_name: self.shop.name, plan: plan, link_invoice: generate_url_invoice, link_subscription: get_users_subscription_url)
    send_wa_notification(template.template_name, params) if can_send_wa(template, params)
    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
    
  end

  def send_ops_payment_pending_notification
    #send to ops only for staging and production
    subscription = Subscription.find(self.id)
    plan = self.plan_i18n
    if Rails.env.staging? || Rails.env.development?
      subject = I18n.t('subscription.email.subject.stg_ops_pending_payment_received', shop_name: self.shop.name)
    else
      subject = I18n.t('subscription.email.subject.ops_pending_payment_received', shop_name: self.shop.name)
    end
    body = I18n.t('subscription.email.body.ops_pending_payment_received', 
      shop_virtual_account: self.shop.virtual_bank_no, 
      shop_name: self.shop.name, 
      id: subscription.order_ids, 
      date: date_with_timezone(self.created_at), 
      plan: plan, 
      email: self.shop.shop_group.owner_email,
      link: get_console_subscription_url(self.id)
    )
    send_internal_email(subject, body)
  end

  def send_ops_application_received_notification
    #send to ops only for staging and production
    plan = self.plan_i18n
    va =  VaCodeArea.find(self.va_code_area_id) if self.va_code_area_id.present? 
    subscription = Subscription.find(self.id)
    subs_period = Subscription.periods[self.period].to_i
    
    if Rails.env.staging? || Rails.env.development?
      subject = I18n.t('subscription.email.subject.stg_ops_application_received', shop_name: self.shop.name)
    else
      subject = I18n.t('subscription.email.subject.ops_application_received', shop_name: self.shop.name)
    end
    
    body = I18n.t(
      'subscription.email.body.ops_application_received', 
      id: subscription.order_ids,
      owner_name: self.shop_group.owner_name,
      shop_name: self.shop.name, 
      email: self.shop.shop_group.owner_email,
      plan: plan, 
      period: subs_period,
      pay_amount: self.fee,
      shop_address: self.shop.address,
      area_name: va&.area_name,
      area_code: va&.va_code,
      shop_id: self.shop.bengkel_id,
      shop_virtual_account: self.shop.virtual_bank_no,
      sales_name: self.sales_name,
      link: get_console_subscription_url(self.id)
    )
    
    send_internal_email(subject, body)
  end

  def send_ops_returning_application_received_notification
    plan = self.plan_i18n
    va =  VaCodeArea.find(self.va_code_area_id) if self.va_code_area_id.present? 
    subscription = Subscription.find(self.id)
    subs_period = Subscription.periods[self.period].to_i
    
    if Rails.env.staging? || Rails.env.development?
      subject = I18n.t('subscription.email.subject.stg_ops_returning_application_received', shop_name: self.shop.name)
    else
      subject = I18n.t('subscription.email.subject.ops_returning_application_received', shop_name: self.shop.name)
    end
    
    body = I18n.t(
      'subscription.email.body.ops_returning_application_received', 
      id: subscription.order_ids,
      owner_name: self.shop_group.owner_name,
      shop_name: self.shop.name,
      email: self.shop.shop_group.owner_email,
      plan: plan,
      period: subs_period,
      pay_amount: self.fee,
      shop_address: self.shop.address,
      area_name: va&.area_name,
      area_code: va&.va_code,
      shop_id: self.shop.bengkel_id,
      shop_virtual_account: self.shop.virtual_bank_no,
      sales_name: self.sales_name,
      link: get_console_subscription_url(self.id)
    )
    
    send_internal_email(subject, body)
  end

  def send_cancel_notification
    plan = self.plan_i18n
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_cancelled])
    params = [self.shop.name, plan]
    subject = I18n.t('subscription.email.subject.cancelled', id: self.id)
    body = I18n.t('subscription.email.body.cancelled', shop_name: self.shop.name, plan: plan)
    send_wa_notification(template.template_name, params) if can_send_wa(template, params)
    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def send_expired_notification
    plan = self.plan_i18n
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_cancelled])
    params = [self.shop.name, plan]
    subject = I18n.t('subscription.email.subject.expired', id: self.id)
    body = I18n.t('subscription.email.body.expired', shop_name: self.shop.name, plan: plan)
    send_wa_notification(template.template_name, params) if can_send_wa(template, params)
    send_email_notification(self.shop_group.owner_email , subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def send_renewal_subscription_proforma(payment_period = ENV['PAYMENT_PERIOD'].to_i)
    plan = self.plan_i18n
    va_number =  self.shop.virtual_bank_no.present? ? self.shop.virtual_bank_no : "-"
    payment_expired_date = Date.today.in_time_zone('Jakarta').to_date + payment_period.days
    order_ids = Subscription.find(self.id).order_ids

    params = [self.shop.name, plan, self.fee.to_s, va_number, payment_expired_date ]
    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:subscription_bank_account_created])
    subject = I18n.t('subscription.email.subject.payment_pending', id: order_ids) 
    body = I18n.t('subscription.email.body.payment_pending', shop_name: self.shop.name, plan: plan, fee: self.fee, bank_no: va_number)
    
    send_whatsapp_notification(template, params) if can_send_wa(template, params) 
    send_email_notification(self.shop_group.owner_email, subject, body, get_internal_emails) if can_send_email(subject, body)
  end

  def days_remaining
    if self.end_date.present?
      (Date.parse(self.end_date.to_s)-Date.today).to_i
    else
      0
    end
  end

  def ppn_value
    ppn_value = 10.to_f / 100.to_f
  end

  def change_plan_time
    if self.end_date.present?
      date = Otoraja::DateUtils.parse_date_tz(self.end_date.to_s)  
    end
  end

  def subtotal
    self.fee / (1 + ppn_value)
  end

  def total_of_ppn
    subtotal * ppn_value
  end

  def update_payment_pending(virtual_bank_no)
    payment_expired_date = Date.today + ENV['PAYMENT_PERIOD'].to_i
    weekdays_payment_expired_date = ApplicationController.helpers.convert_to_weekdays(payment_expired_date) + 14.hours

    self.shop.update_attributes(
      virtual_bank_no: virtual_bank_no,
    )

    self.update!(
      status: :payment_pending,
      payment_expired: weekdays_payment_expired_date
    )
  end

  def update_finalization(params)
    payment_date = Date.strptime(params[:payment_date], '%d-%m-%Y')
    
    if self.shop.non_subscriber? || self.shop.is_reactivated.present?
      start_date = payment_date
    elsif (self.shop.subscriber? || self.shop.paid_subscriber?) && self.shop.expiration_date.present?
      start_date = self.shop.expiration_date
    else
      start_date = payment_date
    end

    period = Subscription.periods[self.period].to_i
    expiration_date = Shop.subscription_end_period(start_date, period)

    self.shop.update_attributes(
      expiration_date: expiration_date,
      subscriber_type: Shop.subscriber_types[:paid_subscriber]
    )
    self.update!(
      start_date: start_date,
      end_date: expiration_date,
      invoice_number: params[:invoice_number],
      form_number: params[:form_number],
      status: :finalized,
      payment_date: payment_date
    ) 
  end

  def cancel_subscription(message)
    last_subscription = self.shop.subscriptions.shop_plan_subscription.last
    
    self.update!(
      status: :cancelled,
      reason_for_cancellation: message
    )

    self.shop.update!(active_plan:  last_subscription.id) if last_subscription.present?
    self.send_cancel_notification
  end

  def date_with_timezone(date)
    ApplicationController.helpers.formatedDateTime(date, "Jakarta", true)
  end

  

  class << self
    def active_subscription(shop_group_id)
      shop_group = ShopGroup.find(shop_group_id)
      unless shop_group.active_plan.nil?
        Subscription.find(shop_group.active_plan)
      end
    end

    def active_shop_subscription(shop_id)
      shop = Shop.find(shop_id)
      unless shop.active_plan.nil?
        Subscription.find(shop.active_plan)
      end
    end

    def expired_subscriptions(shop_group_id)
      Subscription.expire.where(shop_group_id: shop_group_id).where(end_date: Date.today)
    end

    def expired
      get_shop_group.finalized.where(end_date: Date.today)
    end

    def renewals
      get_shop_group.finalized.where(end_date: Date.today + ENV['PAYMENT_PERIOD'].to_i)
    end

    def unpaid
      get_shop_group.payment_pending.where(end_date: Date.today - ENV['PAYMENT_PERIOD'].to_i)
    end
  end

  def subscription_period
    Subscription.periods[self.period]
  end

  def payment_deadline
    time = (DateTime.now.in_time_zone('UTC') - self.payment_gateway_expired)
    Time.at(time.to_i.abs).utc.strftime "%H:%M:%S"
  end
  
  def payment_method
    payment_type_id = self.payment_type_id.nil? && self.status == "4" ? 'sinarmas_va' : self.payment_type_id
    #Subscription.payment_type_ids_i18n[payment_type_id]
  end

  def payment_gateway_transaction(params)
    payment_method = PaymentType.find(params[:payment_method]) 
    payment_gateway = PaymentGateway.find_by(is_active: true)
    merchant_id = ENV['DOMAIN_NAME'] == 'dev-biz.otoraja.id' ? 2 : payment_gateway.merchant_id;

    self.status = :payment_pending
    self.payment_type = payment_method
    self.save!

    data = { 
      merchant_id: merchant_id,
      payment_type_id: payment_method.payment_type_id,
      va_number: self.shop.tel,
      order_id: "#{Subscription.find(self.id).order_ids}-#{self.id}", 
      expiry: payment_method.expiration_interval, 
      currency: "IDR", 
      total_paid: self.fee, 
      total_tax: 0, 
      description: "Pembelian Paket #{self.subscription_period} Bulanan Bengkel #{self.shop.name}", 
      is_partial: false 
    }

    response = Payment::PaymentUtility.create_payment(data)

    if response['code'] == '200'
      due_date = response["data"]["transaction"]["due_date"]
      self.update!(payment_transaction_id:  response['data']['transaction']['id'])

      if response["data"]["va_numbers"].present?
        va_number = response["data"]["va_numbers"].first["va_number"]
        self.update!(payment_gateway_expired: ApplicationController.helpers.formattedDateTimePicker(due_date), payment_gateway_va: va_number)
      end
      
      if response["data"]["mandiri_bill"].present?
        va_number = response["data"]["mandiri_bill"]["bill_key"]
        self.update!(payment_gateway_expired: ApplicationController.helpers.formattedDateTimePicker(due_date), payment_gateway_va: va_number)
      end
      
      if response["data"]["transaction_callback"].present?
        qr_path = response["data"]["transaction_callback"].first["url"]
        self.update!(payment_gateway_expired: ApplicationController.helpers.formattedDateTimePicker(due_date), qr_path: qr_path)
      end
      
      transaction_id = response['data']['transaction']['id']
      response_status = response['code']
  
      transaction_log = TransactionLog.new(
        transaction_id: transaction_id,
        subscription_id: self.id,
        request: data.to_json,
        response: response.to_json,
        response_status: response_status
      )
      
      transaction_log.save!

      if self.shop.returning_customer?
        self.send_ops_returning_application_received_notification
      else
        self.send_ops_application_received_notification
      end
      
      self.shop.update!(active_plan: self.id)
      self.send_processing_notification
      self.send_payment_instruction_notification(payment_method.name) if payment_gateway
    else
      raise ActiveRecord::Rollback
    end
  end

  def manual_transaction
    self.status = :processing
    self.payment_type_id = nil
    self.save!

    if self.shop.returning_customer?
      self.send_ops_returning_application_received_notification
    else
      self.send_ops_application_received_notification
    end

    self.shop.update!(active_plan: self.id)
    self.send_processing_notification
  end

  def cancel_payment_gateway_transaction
    data = { 
      order_id: "#{self.order_ids}-#{self.id}",
      reason_cancellation: "Pembatalan Paket #{self.period} Bulanan Bengkel #{self.shop.name}"
    }

    Payment::PaymentUtility.cancel_payment(data)
  end

  private

  def can_send_wa(template, params)
    template.present? && params.present?
  end

  def can_send_email(subject, body)
    subject.present? && body.present?
  end

  def send_internal_email(subject, body)
    send_email_notification(ENV['SALES_EMAIL'] , subject, body)
    send_email_notification(ENV['PRODUCT_EMAIL'] , subject, body)
    send_email_notification(ENV['FINANCE_EMAIL'] , subject, body)
  end

  def get_internal_emails
    if Rails.env.staging? || Rails.env.production?
      [ENV['SALES_EMAIL'],ENV['PRODUCT_EMAIL'],ENV['FINANCE_EMAIL']]
    end
  end
  
  def send_wa_notification(template, params)
    unless self.shop_group.owner_wa_tel.blank?
      shop_name = self.shop_group.name
      send_message = SendMessage.create(
        from: "system", 
        to: self.shop_group.owner_wa_tel, 
        body: template, 
        send_type: :wa, 
        send_purpose: :subscription_update, 
        send_datetime: DateTime.now,
        resend_attempts: 0,
        parameters: params.to_json
      )
      @data = {
        'to' => [send_message.to],
        'param'=> params
      }
      response = Whatsapp::WhatsappUtility.send_hsm(template, @data)
      #if the template is not found or has not been binded, response will not contain the data property
      #this situation can and did occur when whats app business account phone number was changed
      unless response["data"].nil?
        data = response["data"].first unless response["data"].nil?
        send_message.update(sent_at: DateTime.now, message_id: data["msgId"], send_status: data["status"])
      else
        logger.warn("Whats App template #{template} may be misspelled or has not been binded to What App phpne number")
        send_message.update(sent_at: DateTime.now, send_status: "bad request")
      end
    end
  end

  def send_whatsapp_notification(template, params)
    whatsapp_object = {
      to: self.shop_group&.owner_wa_tel, 
      from: "system", 
      template: template, 
      send_purpose: :subscription_update, 
      params: params
    }

    Whatsapp::WhatsappUtility.send_wa_notification(whatsapp_object)
  end

  def send_email_notification(receiver, subject, body, cc = '')
    if receiver.present?
      # uncomment this line to test email on dev
      # Email::EmailUtility.send_email_on_development(receiver, subject, body)
      
      SendMessage.create(
        to: receiver,
        from: 'noreply@otoraja.com',
        subject: subject,
        body: body,
        send_type: :email,
        send_purpose: :subscription_update,
        send_datetime: DateTime.now
      )
    elsif cc.present?
      if cc.is_a?(Array)
          cc.each do |cc|
            SendMessage.create(
            to: cc,
            from: 'noreply@otoraja.com',
            subject: subject,
            body: body,
            send_type: :email,
            send_purpose: :subscription_update,
            send_datetime: DateTime.now
          )
        end
      elsif cc.is_a?(String)
        SendMessage.create(
          to: cc,
          from: 'noreply@otoraja.com',
          subject: subject,
          body: body,
          send_type: :email,
          send_purpose: :subscription_update,
          send_datetime: DateTime.now
        )
      end
    end
  end

  def get_console_subscription_url(id)
    if Rails.env.production?
      "https://host.otoraja.id/console/subscriptions/#{id}/edit"
    elsif Rails.env.staging?
      "https://stg-host.otoraja.id/console/subscriptions/#{id}/edit"
    else
      "http://localhost:3000/console/subscriptions/#{id}/edit"
    end
  end

  def get_users_subscription_url
    host = ENV['DOMAIN_NAME'] || 'localhost'
    if Rails.env.production? || Rails.env.staging?
      protocol = 'https://'
    else
      protocol = 'http://'
    end  
    url = "#{protocol}#{host}#{admin_subscriptions_path}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def generate_url_invoice
    token = create_invoice_token
    host = ENV['DOMAIN_NAME'] || 'localhost'

    if Rails.env.production? || Rails.env.staging?
      protocol = 'https://'
    else
      protocol = 'http://'
    end  
    
    url = "#{protocol}#{host}#{receipt_output_for_subscriptions_public_path(token.uuid)}"
    Otoraja::ShortUrl.generate_short_url(url)
  end

  def create_invoice_token
    expired_at = DateTime.now + 30.days
    token = Token.create_invoice_token(self.id, expired_at)
  end

end
