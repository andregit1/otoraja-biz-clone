class ShopConfig < ApplicationRecord
  after_initialize :set_default_values, if: :new_record?

  belongs_to :shop

  validates :questionnaire_expiration_days, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :customer_remind_interval_days, :allow_nil => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :receipt_open_expiration_days, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :stock_notification_destination, length: { maximum: 255 }

  enum front_priority_display: {
    'No. Polisi': 'number_plate',
    'No telpon': 'phone_number',
    'Nama Pelanggan': 'customer_name',
    }, _prefix: true

  enum receipt_layout: {
    'A4 Vertikal': 'A4_portrait',
    '1/3 Vertikal': 'cut_portrait',
  }, _prefix: true

  enum rounding_direction: {
    'Up': 'Up', 
    'Down': 'Down',
  }
  
  enum round_to:{
    '100': 100,
    '1000': 1000
  }

  scope :own_shop_config, ->(shops) {
    where(shop_configs: { shop: shops } )
  }

  scope :own_shop, ->(shop_ids) {
    where(shop_configs: { shop: shop_ids } )
  }

  def front_priority_display_number_plate?
    self.front_priority_display_before_type_cast == 'number_plate'
  end

  def front_priority_display_phone_number?
    self.front_priority_display_before_type_cast == 'phone_number'
  end

  def front_priority_display_customer_name?
    self.front_priority_display_before_type_cast == 'customer_name'
  end

  def receipt_layout_A4_portrait?
    self.receipt_layout_before_type_cast == 'A4_portrait'
  end

  def receipt_layout_Cut_portrait?
    self.receipt_layout_before_type_cast == 'cut_portrait'
  end

  def trim_stock_notification_destination
    Phonelib.parse(stock_notification_destination).raw_national unless self.stock_notification_destination.nil?
  end

  private
    def set_default_values
      self.front_priority_display ||= 'number_plate'
      self.use_customer_remind ||= true
      self.use_receipt ||= true
      self.customer_remind_interval_days ||= 60
      self.receipt_layout ||= 'cut_portrait'
      self.receipt_open_expiration_days ||= 30
      self.close_stock_time ||= Time.local(2019, 1, 1, 14)
      self.use_record_stock ||= true
      self.use_stock_notification ||= true
      self.num_of_products_in_custom_list ||= 15
      self.num_of_custom_list ||= 15
      self.rounding_direction ||= 'Down'
      self.round_to ||= 100
    end
end
