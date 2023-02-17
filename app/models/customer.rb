class Customer < ApplicationRecord
  include CustomerSearchable

  has_many :checkins
  has_many :shops, through: :checkins

  has_many :owned_bikes
  has_many :bikes, through: :owned_bikes

  has_many :customer_reminder_logs

  belongs_to :region, optional: true
  belongs_to :province, optional: true
  belongs_to :regency, optional: true

  has_many :whats_app_invites
  has_many :whats_app_optins

  validates :tel, uniqueness: true, allow_blank: true, allow_nil: true

  enum receipt_type: { no: 0, paper: 1 }
  enum send_type: {sms: 0, wa: 1, sms_wa: 2}

  before_save :before_save_wa_tel

  scope :own_shop, ->(shop_ids) {
    joins(:checkins).where(checkins: { shop_id: shop_ids } ).group(:id)
  }

  def last_checkin_datetime
    checkins.order(datetime:'DESC').first.datetime
  end

  def last_checkin
    checkins.order(datetime:'DESC').first  
  end

  def to_agree
    terms = Term.where('effective_date <= ?', DateTime.now).where(terms_purpose: :to_bengkel).order('effective_date DESC').first
    
    if self.terms_agreed_at.nil?
      return true
    else
      return terms.effective_date > self.terms_agreed_at
    end
  end
  
  def self.generate_csv(user)
    CSV.generate do |csv|
      type =  ExportType.find_by(name: 'CustomerList')
      csv_columns = user.export_columns(type)
      csv_column_names = csv_columns.map {|layout_columun| layout_columun.export_column.name}

      csv << csv_column_names

      all.find_each do |customer|
        csv_column_values = []
        csv_columns.each do |column|
          column_name = column.export_column.name
          value = customer[column_name]
          value = value&.in_time_zone('Jakarta')&.strftime('%Y/%m/%d %H:%M') if column_name === 'terms_agreed_at'

          masking_rule = column.export_masking_rule
          if masking_rule&.use_masking
            value = masking_rule.masking(value)
          end

          csv_column_values.push(value)
        end
        csv << csv_column_values
      end
    end
  end

  private
  def before_save_wa_tel
    return unless self.tel.present?
    # If a phone number is entered, it will be used as the phone number for Whasapp.
    if self.wa_tel.blank?
      self.wa_tel = self.tel
      self.send_type = :sms_wa
    end
  end
end
