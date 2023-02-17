class Shop < ApplicationRecord
  has_many :shop_products
  has_many :checkins
  has_many :customers, through: :checkins
  has_many :shop_visiting_reasons
  has_many :visiting_reasons, through: :shop_visiting_reasons
  has_many :shop_staffs
  has_many :campaigns
  has_many :shop_available_payment_methods
  has_many :payment_methods, through: :shop_available_payment_methods
  has_many :available_shops
  has_many :users, through: :available_shops
  has_many :shop_business_hours
  has_many :shop_facilities
  has_many :facilities, :through => :shop_facilities
  has_many :shop_services
  has_many :subscriptions
  has_many :suppliers
  has_many :services, :through => :shop_services
  has_many :shop_search_tags
  has_many :shop_whats_app_templates
  has_many :notifications
  has_one :shop_config
  has_one_attached :shop_logo
  belongs_to :shop_group, optional: true
  belongs_to :region, optional: true
  belongs_to :province, optional: true
  belongs_to :regency, optional: true
  accepts_nested_attributes_for :shop_business_hours
  accepts_nested_attributes_for :shop_search_tags
  accepts_nested_attributes_for :shop_config

  validates :name, length: { maximum: 255 }, presence: true
  validates :tel, length: { maximum: 255 }, presence: true, on: :update_shop
  validates :tel2, length: { maximum: 255 }
  validates :tel3, length: { maximum: 255 }, presence: true, on: :update_shop
  validates :address, length: { maximum: 255 }, presence: true, on: :update_shop
  validates :region_id, presence: true, on: :update_shop
  validates :province_id, presence: true, on: :update_shop
  validates :regency_id, presence: true, on: :update_shop

  enum subscriber_type: {
    non_subscriber: 0,
    subscriber: 1,
    paid_subscriber: 2
  }

  scope :own_shop, ->(shop_ids) {
    where(shops: { id: shop_ids } )
  }

  scope :pilot_shops, -> {
    joins(:available_shops).distinct
  }

  before_create :set_bengkel_id
  after_create :create_shop_config
  after_create :create_search_tags

  def has_staff_account?
    has_role_account(:staff)
  end

  def subs_active_plan?
    Subscription.find(self.active_plan)
  end

  def has_manager_account?
    has_role_account(:manager)
  end

  def has_shop_manager_account?
    has_role_account(:shop_manager)
  end

  def has_owner_account?
    has_role_account(:owner)
  end

  def id_name
    "#{self.id}:#{self.name}"
  end

  def bengkel_id_name
    "#{self.bengkel_id}:#{self.name}"
  end

  def set_bengkel_id
    self.bengkel_id = Shop.maximum(:bengkel_id).to_i + 1 if self.bengkel_id.nil?
    self
  end

  def create_shop_config
    return unless self.shop_config.nil?
    
    shop_config = ShopConfig.create!(shop: self)

    payment_method_array = PaymentMethod.where(id: [1,2,5])

    shop_config.stock_notification_destination = self.tel
    shop_config.shop.payment_methods = payment_method_array
    shop_config.save!

  end

  def create_search_tags
    return unless ShopSearchTag.find_by(shop: self).nil?
    tags = []
    SearchTag.all.each_with_index do |tag, index|
      tags << ShopSearchTag.new(shop: self, name: tag.tag, order: index, is_using: true)
    end

    ShopSearchTag.import tags
  end

  def active_subscription
    if self.active_plan.present?
      Subscription.find(self.active_plan)
    end
  end

  def days_remaining
    if self.expiration_date.present?
      (Date.parse(self.expiration_date.to_s)-Date.today).to_i
    else
      0
    end
  end

  def change_plan_time? 
    subscription = self.active_subscription
    subscription.present? && (subscription.payment_pending? || subscription.payment_gateway_expired? || subscription.payment_gateway_renewal?)
  end

  def in_grace_period?
    days_remaining <= ENV['PAYMENT_PERIOD'].to_i
  end

  def status_processing?
    self.active_subscription&.processing? || self.active_subscription&.creating_bank_account? || self.active_subscription&.payment_confirmed?
  end

  def payment_pending?
    self.active_subscription&.payment_pending?
  end

  def payment_expired?
    self.active_subscription.payment_expired < (DateTime.now + 7.hours) if self.active_subscription.payment_expired.present?
  end

  def demo_period?
    self.active_subscription&.demo_period?
  end

  def finalized?
    self.active_subscription&.finalized?
  end

  def cancelled?
    self.active_subscription&.cancelled?
  end

  def will_run_out?
    self.in_grace_period? && self.expiration_date.present? && !self.non_subscriber? 
  end

  def payment_gateway_active?
    PaymentGateway.find_by(is_active: true) && self.payment_method_active?
  end

  def payment_type_list
    PaymentType.where("is_active = TRUE AND (shop_list like ? OR is_use_all IS TRUE )",  "%#{self.bengkel_id}%")
  end

  def in_list_payment_gateway?
    PaymentGateway.find_by(is_active: true) && self.payment_type_list.present?
  end

  def in_processing_subscription?
    self.status_processing? || self.payment_pending?
  end

  def receipt_upload_active?
    self.in_list_payment_gateway? && self.payment_pending? && self.payment_method_active?
  end

  def payment_gateway_expired?
    subscription = self.active_subscription
    if self.payment_gateway_active? 
      if subscription&.payment_pending? && subscription.payment_gateway_expired.present? 
        ApplicationController.helpers.formatedDateTime(DateTime.now, 'Jakarta', false) >= DateTime.parse(subscription.payment_gateway_expired.to_s)
      else
        subscription.payment_gateway_expired?
      end
    else
      false
    end
  end

  def payment_gateway_pending?
    self.payment_pending? && self.in_list_payment_gateway? && self.payment_method_active?
  end

  def payment_gateway_renewal?
    self.active_subscription&.payment_gateway_renewal?
  end

  def payment_method_active?
    self.active_subscription&.payment_type_id.present?
  end

  def have_active_plan?
    self.active_subscription.present?
  end

  def start_subscribing?
    unless self.change_plan_time? || self.status_processing?
      self.active_subscription&.demo_period? || self.non_subscriber? || self.in_grace_period? || self.active_plan.blank? || self.cancelled?
    end
  end

  def grace_period?
    if self.active_subscription.present? && self.active_subscription.payment_expired
      self.active_subscription.payment_expired > self.expiration_date ? Date.parse(self.active_subscription.payment_expired.to_s) : false
    else
      false
    end
  end

  def subscription_period
    Subscription.periods[self.active_subscription.period] if self.active_subscription.present?
  end

  def set_payment_gateway_expired
    self.active_subscription.update_attributes(
      status: :payment_gateway_expired, 
      payment_transaction_id: nil,
      qr_path: nil,
      payment_gateway_expired: nil,
    )
  end

  def have_receipt?
    if self.have_active_plan?
      self.payment_gateway_active? && self.active_subscription.finalized? && (self.paid_subscriber? || self.non_subscriber?)
    else
      false
    end
  end

  def payment_gateway_expired_update
    if self.have_active_plan? && self.payment_gateway_expired? && self.payment_gateway_pending?
      self.active_subscription.update_attributes(status: :payment_gateway_expired)
    end
  end

  def returning_customer?
    self.have_active_plan? && !self.demo_period?
  end

  class << self
    def subscription_end_period(start_date, period)
      start_date + period.month
    end  
  end

  private
  def has_role_account(role)
    self.users.where(role: role).exists?
  end
end
