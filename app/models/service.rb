class Service < ApplicationRecord
  has_many :shop_services
  has_many :shops, :through => :shop_services

  validates :name, length: { maximum: 255 }, uniqueness: true, presence: true
end
