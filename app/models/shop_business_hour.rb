class ShopBusinessHour < ApplicationRecord
  belongs_to :shop
  enum day_of_weeks:[:mon, :tue, :wed, :thu, :fri, :sat, :sun]
  def open_time
    "#{format('%02d', self.open_time_hour)}:#{format('%02d', self.open_time_minute)}" if self.open_time_hour.present? && self.open_time_minute.present?
  end
  def close_time
    "#{format('%02d', self.close_time_hour)}:#{format('%02d', self.close_time_minute)}" if self.close_time_hour.present? && self.close_time_minute.present?
  end
end
