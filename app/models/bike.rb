class Bike < ApplicationRecord
  has_one :owned_bike

  after_save :update_odometer_updated_at

  def self.bike_color_list
    { 
      "Putih" => "white", 
      "Hitam" => "black",
      "Abu-abu" => "gray",
      "Merah" => "merah",
      "Hijau" => "green",
      "Kuning" => "yellow",
      "Jingga" => "orange",
      "Pink" => "pink",
      "Ungu" => "purple",
      "Coklat" => "brown",
      "Emas" => "gold",
      "Silver" => "silver",
      "Lainnya" => "other"
    }
  end

  def self.number_plate_area
    ['A','B','D','E','F','G','H','K','L','M','N','P','R','S','T','W','Z','AA','AB','AD','AE','AG','BA','BB','BD','BE','BG','BH','BK','BL','BM','BN','BP','DA','DB','DC','DD','DE','DG','DH','DK','DL','DM','DN','DR','DS','DT','EA','EB','ED','KB','KH','KT']
  end

private
  def update_odometer_updated_at
    if self.odometer.present?
      previous_odometer = self.odometer_before_last_save || 0
      self.update_columns(odometer_updated_at: DateTime.now) if previous_odometer != self.odometer
    end
  end
end
