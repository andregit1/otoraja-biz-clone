class Supplier < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  belongs_to :shop
  validates :name, length: { maximum: 255 }
  validates :name, uniqueness: {
    scope: [:shop_id, :address, :tel]
  }
  validates :address, length: { maximum: 255 }
  validates :tel, length: { maximum: 20 }
  validates :tel, phone: { possible: true, allow_blank: true }
  scope :own_shop, ->(shop_ids) {
    joins(:shop).where(shops: { id: shop_ids } )
  }

  self.discard_column = :deleted_at
end
