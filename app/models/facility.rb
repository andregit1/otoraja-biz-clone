class Facility < ApplicationRecord
  has_many :shop_facilities
  has_many :shops, :through => :shop_facilities

  validates :name, length: { maximum: 255 }, uniqueness: true, presence: true
end
