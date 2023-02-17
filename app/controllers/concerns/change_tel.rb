module ChangeTel
  extend ActiveSupport::Concern

  include AwsSns

  included do
    helper_method :create_token_for_change_tel
    helper_method :create_token_and_send_sms
    helper_method :create_token_and_send_email
  end

  def create_token_for_change_tel(customer)
    # 有効期限設定
    expired_at = DateTime.now.since(1.days)
    # Token生成
    token = Token.create_email_token(customer, expired_at)
    # 短縮URL
    path = "/forgot/"
    url = generate_mypage_url(token, path)

    # メール件名
    subject = I18n.t('member.token.change_tel.mail_subject')
    # メール本文
    body = "#{I18n.t('member.token.change_tel.mail_body')}#{url}"

    # メール送信のためにsend_messaageへinsert
    SendMessage.create(
      to: customer.email,
      from: 'noreply@otoraja.com',
      subject: subject,
      body: body,
      send_type: :email,
      send_purpose: :customer_change_tel,
      send_datetime: DateTime.now
    )
  end

  def create_token_and_send_sms(customer, tmp_tel)
    customers = Customer.find_by(tel: tmp_tel)
    if customers.nil?
      # 電話番号を保存
      customer.tmp_tel = tmp_tel
      customer.save

      # 有効期限設定
      expired_at = DateTime.now.since(1.days)
      # Token生成
      token = Token.create_confirm_sms_token(customer, expired_at)

      # 短縮URL
      path = "/change/phone_number/"
      url = generate_mypage_url(token, path)

      body = "#{I18n.t('member.token.sms_body')}#{url}"
      # SMS送信
      send_message = SendMessage.create(
        to: customer.tmp_tel,
        body: body,
        send_type: :sms,
        send_purpose: :customer_change_tel,
        send_datetime: DateTime.now
      )
      send_sms(customer.tmp_tel, body)
    else
      duplication
    end
  end


  def create_token_and_send_email(customer, tmp_email)
    customers = Customer.find_by(email: tmp_email)
    if customers.nil?
      # メールアドレスを保存
      customer.tmp_email = tmp_email
      customer.save
      # 有効期限設定
      expired_at = DateTime.now.since(1.days)
      # Token生成
      token = Token.create_email_token(customer, expired_at)

      # 短縮URL
      path = "/change/email/"
      url = generate_mypage_url(token, path)

      # メール件名
      subject = I18n.t('member.token.change_mail.mail_subject')
      # メール本文
      body = "#{I18n.t('member.token.change_mail.mail_body')}#{url}"

      # メール送信のためにsend_messaageへinsert
      SendMessage.create(
        to: customer.tmp_email,
        from: 'noreply@otoraja.com',
        subject: subject,
        body: body,
        send_type: :email,
        send_purpose: :customer_change_mail,
        send_datetime: DateTime.now
      )

    else
      duplication
    end
  end

  private
    def duplication
      raise ActionController::RoutingError.new('Duplication')
    end

    def generate_mypage_url(token, path)
      if Rails.env.production?
        url = "https://my.otoraja.com#{path}#{token.uuid}"
      elsif Rails.env.staging?
        url = "https://stg-my.otoraja.com#{path}#{token.uuid}"
      else
        url = "http://localhost:8080#{path}#{token.uuid}"
      end
      return Otoraja::ShortUrl.generate_short_url(url)
    end

end
