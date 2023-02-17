class NewContractRequest < ApplicationRecord

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, unless: -> {email.blank?}
  validates :tel, presence: true, length: { maximum: 255 }
  validates :tel, numericality: true, unless: -> {tel.blank?}
  validates :shop_name, presence: true, length: { maximum: 255 }
  validates :shop_address, length: { maximum: 255 }
  validates :regency_id, presence: true
  validates :distric_id, presence: true
  
  enum business_form: [
    'small','medium','large'
  ]

  enum number_of_employees: [
    '-9','10-49','50-'
  ]

  enum status: {
    todo: 0,
    processing: 1,
    processed: 2
  }, _prefix: true

  before_save :set_status
  attr_accessor :phone_country_code

  def set_status
    if self.status.nil?
      self.status = :todo
    end
    self
  end

  def self.destroy_request(id)
    user = User.find_by(id: id)
    unless user.nil?
      NewContractRequest.find_by(email: user.user_id).destroy
    end
  end
end
