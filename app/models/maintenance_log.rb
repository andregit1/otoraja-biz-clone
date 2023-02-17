class MaintenanceLog < ApplicationRecord
  include UserstampsConcern

  has_many :maintenance_log_details
  has_many :shop_products, through: :maintenance_log_detail
  has_many :maintenance_log_payment_methods
  has_many :payment_methods, through: :maintenance_log_payment_methods
  has_many :cash_flow_histories, as: :cashable
  belongs_to :checkin
  belongs_to :maintained_staff, class_name: 'ShopStaff', optional: true
  accepts_nested_attributes_for :maintenance_log_details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :maintenance_log_payment_methods, reject_if: :all_blank, allow_destroy: true

  validates :checkin_id, presence: true, numericality: true
  validates :mileage, length: { maximum: 10 }, numericality: true, unless: -> { mileage.blank? }
  validates :model, length: { maximum: 45 }
  validates :number_plate_area, length: { maximum: 2 }
  validates :number_plate_number, length: { maximum: 4 }, numericality: true, unless: -> { number_plate_number.blank? }
  validates :number_plate_pref, length: { maximum: 3 }
  validates :expiration_month, numericality: true, unless: -> { expiration_month.blank? }
  validates :expiration_year, numericality: true, unless: -> { expiration_year.blank? }
  validates :total_price, length: { maximum: 10 }, numericality: true, unless: -> { total_price.blank? }

  enum displacements:['1cc - 50cc', '51cc - 125cc', '126cc - 250cc', '251cc - 500cc', '501cc - 1000cc', '1001cc - 1500cc', '1501cc - 2000cc', '2001cc - 9999cc', 'Electric Powered', 'Pedelec']
  enum number_plate_areas: ['A','B','D','E','F','G','H','K','L','M','N','P','R','S','T','W','Z','AA','AB','AD','AE','AG','BA','BB','BD','BE','BG','BH','BK','BL','BM','BN','BP','DA','DB','DC','DD','DE','DG','DH','DK','DL','DM','DN','DR','DS','DT','EA','EB','ED','KB','KH','KT']
  enum colors: ['white','black','gray','blue','red','green','yellow','orange','pink','purple','brown','gold','silver','other']

  scope :get_mechanic_name, ->(){
    joins(:maintenance_log_details).join(:maintenance_mechanics).join(:shop_staff).select("shop_staffs.name")
  }

  scope :own_shop, ->(shop_ids) {
    joins(:checkin).where(checkins: { shop_id: shop_ids } ).group(:id)
  }

  scope :get_histories, ->(checkin, limit = 3) {
    # チェックインの顧客に紐づくメンテナンスログを作成日の降順で取得する
    # 指定されたチェックインは除外する
    where(checkins: {customer_id: checkin.customer.id}).where.not(checkin: checkin).order(created_at: 'DESC').limit(limit)
  }

  scope :get_histories_by_customer_id, ->(customer_id, exclude_id = nil) {
    # チェックインの顧客に紐づくメンテナンスログを作成日の降順で取得する
    # 指定されたチェックインは除外する

    if(exclude_id.nil? || exclude_id.blank?)
      joins(:checkin).where(checkins: {customer_id: customer_id}).order(created_at: 'DESC')
    else
      joins(:checkin).where(checkins: {customer_id: customer_id}).where.not(id: exclude_id).order(created_at: 'DESC')
    end
  }

  scope :get_mechanic_transactions_for_range, ->(staff_id, start_datetime, end_datetime){
    where("created_at between ? and ?", start_datetime, end_datetime).where(maintained_staff_id: staff_id)
  }

  after_save :set_total_price
  after_save :update_odometer_updated_at

  def sum_cashable_amount(cash_type="DOWN_PAYMENT")
    self.cash_flow_histories.where(cash_type: cash_type).inject(0){|sum, down_payment| sum + down_payment.cash_amount}
  end

  def total
    t = 0
    self.maintenance_log_details.each do |detail|
      t += detail.subtotal
    end
    t
  end

  def adjust_price
    sub_total_summary = 0
    self.maintenance_log_details.each do |detail|
      sub_total_summary += detail.sub_total_price
    end
    self.total_price - sub_total_summary if self.total_price.present?
  end

  def v_mileage
    unless self.mileage.nil?
      mileage = self.mileage.to_i * 100
      return "#{mileage.to_s(:delimited, delimiter: '.')}km"
    end
  end

  def has_number_plate
    self.number_plate_area.present? && self.number_plate_number.present? && self.number_plate_pref.present?
  end

  def registered_customer_info
    self.has_number_plate || self.checkin&.customer&.tel.present?
  end

  def has_expiration
    self.expiration_month.present? && self.expiration_year.present?
  end

  def has_maker_model
    self.maker.present? && self.model.present?
  end

  def has_maker_or_model
    self.maker.present? || self.model.present?
  end

  def has_bike_info
    self.has_number_plate && self.has_expiration && self.has_maker_model && self.color.present?
  end

  def has_remarks
    self.remarks.present?
  end

  def formated_number_plate(delimiter=' ')
    "#{self.number_plate_area}#{delimiter}#{self.number_plate_number}#{delimiter}#{self.number_plate_pref}"
  end

  def formated_expiration
    "#{self.expiration_month} / #{self.expiration_year}"
  end

  def formated_maker_model
    "#{self.maker}#{' / ' unless self.model.blank? || self.maker.blank?}#{self.model}"
  end

  def available_payment_methods
    self.checkin.shop.payment_methods
  end

  private
    def set_total_price
      if self.total_price.nil?
        self.maintenance_log_details.each do |detail|
          total = detail.sub_total_price.to_i
        end
        self.update_attributes!(total_price: total) unless total.to_i.zero?
      end
    end

    def update_odometer_updated_at
      if self.odometer.present?
        previous_odometer = self.previous_odometer || 0
        self.update_columns(odometer_updated_at: DateTime.now) if previous_odometer != self.odometer
      end
    end
end
