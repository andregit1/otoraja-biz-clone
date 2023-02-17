class Token < ApplicationRecord
  belongs_to :checkin, optional: true
  belongs_to :customer, optional: true

  enum token_purpose: {
    questionnaire: 1,
    receipt: 2,
    email: 3,
    confirm_sms: 4,
    new_contract_request: 5,
    change_phone_number: 6
  }

  def self.create_questionnaire_token(checkin, expired_at)
    self.create(checkin: checkin, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :questionnaire)
  end

  def self.create_receipt_token(checkin, expired_at)
    self.create(checkin: checkin, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :receipt)
  end

  def self.create_email_token(customer, expired_at)
    self.create(customer: customer, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :email)
  end

  def self.create_confirm_sms_token(customer, expired_at)
    self.create(customer: customer, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :confirm_sms)
  end

  def self.create_change_phone_number_token(customer, expired_at)
    self.create(customer: customer, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :change_phone_number)
  end

  def self.create_new_contract_request(customer_id)
    self.create(customer_id: customer_id, uuid: self.generate_uuid, expired_at: DateTime.now.utc + 24.hours, token_purpose: :new_contract_request)
  end

  def self.create_invoice_token(subscription_id, expired_at)
    self.create(subscription_id: subscription_id, uuid: self.generate_uuid, expired_at: expired_at, token_purpose: :receipt)
  end
  

  def is_expired
    self.expired_at <= DateTime.now.utc
  end

  private
  def self.generate_uuid
    SecureRandom.uuid
  end
end
