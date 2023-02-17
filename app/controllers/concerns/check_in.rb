module CheckIn
  extend ActiveSupport::Concern

  include AwsCognito

  included do
    helper_method :do_checkin
    helper_method :activation_customer
    helper_method :send_wa_notification
  end

  def do_checkin(customer,shop)
    # 顧客情報保存
    checkin = Checkin.create(customer: customer, shop: shop, datetime: DateTime.now, deleted: false)
  end

  def send_wa_notification(tel)
    shop = current_user.shops.first
  
    # Retrieve Attribute to Use Whatsapp Utilities
    object = {
      from: shop.name,
      template: WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:otoraja_customer_register_new_v1]),
      params: [shop.name],
      to: tel,
      send_purpose: SendMessage.send_purposes["customer_register_ty_msg"]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object)
  end

  def activation_customer(customer)
    # 電話番号が設定されていて、Cognito ID,PWが設定されていないもの
    if customer.tel.present? && customer.cognito_id.blank? && customer.cognito_pw.blank?
      (ses, id, pw) = regist_cognito(customer.tel)
      activation_cognito(id, pw, ses)
      customer.cognito_id = id
      customer.cognito_pw = pw
      customer.save
    end
  end
end
  