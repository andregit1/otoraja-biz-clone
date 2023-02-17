class OwnedBike < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :customer
  delegate :maker, to: :bike, allow_nil: true
  delegate :model, to: :bike, allow_nil: true
  delegate :color, to: :bike, allow_nil: true
  delegate :odometer, to: :bike, allow_nil: true
  delegate :odometer_updated_at, to: :bike, allow_nil: true

  scope :get_bikes, ->(customer_id){
    joins(:bike).where(owned_bikes: { customer_id: customer_id }).select('bikes.*','owned_bikes.*').order(created_at: 'DESC')
  }

  scope :check_shop_access, ->(owned_bikes_id, session_shop){
    find_by_sql(<<-SQL)
      SELECT 
        m1.id,
        m1.bike_id,
        m2.name,
        m3.shop_id
      FROM owned_bikes m1 
      JOIN customers m2 on m1.customer_id=m2.id
      JOIN checkins m3 on m2.id=m3.customer_id 
      WHERE m1.id='#{owned_bikes_id}' AND m3.shop_id='#{session_shop}'
      GROUP BY m3.shop_id
    SQL
  }

  ransacker :full_plate_number do
    Arel.sql("CONCAT(
      UPPER(owned_bikes.number_plate_area), 
      UPPER(owned_bikes.number_plate_number), 
      UPPER(owned_bikes.number_plate_pref)
    )")
  end

  def has_number_plate
    self.number_plate_area.present? && self.number_plate_number.present? && self.number_plate_pref.present?
  end

  def has_expiration
    self.expiration_month.present? && self.expiration_year.present?
  end

  def formated_number_plate
    "#{self.number_plate_area} #{self.number_plate_number} #{self.number_plate_pref}"
  end

  def formated_expiration
    "#{self.expiration_month} / #{self.expiration_year}"
  end
end
