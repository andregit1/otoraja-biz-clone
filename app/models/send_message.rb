class SendMessage < ApplicationRecord
  has_one :product_reminder_log
  has_one :customer_reminder_log
  has_one :questionnaire

  enum send_type: { sms: 0, wa: 1, email: 2, auto_create: 99 }
  enum send_purpose: {
    ty: 0,
    purchase_remind: 1,
    customer_remind: 2,
    receipt: 3,
    stock_notification: 4,
    daily_stock_notification: 5,
    customer_change_tel: 6,
    customer_change_mail: 7,
    shop_register_ty_mail: 8,
    subscription_update: 9,
    customer_register_ty_msg: 10,
    mypage_otp: 11,
    change_phone_number: 12,
    cost_estimation: 13,
    other: 99
  }
  # @see https://developers.facebook.com/docs/whatsapp/api/webhooks/outbound#possiblestatus
  # @see https://api-panel.damcorp.id/#send-hsm
  enum wa_send_status: {sent: 0, delivered: 1, read: 2, failed: 3, deleted: 4, invalid: 5, bad_request: 6, unsent: 7}, _prefix: :true
end
