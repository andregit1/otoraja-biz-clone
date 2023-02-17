class ShopSearchTag < ApplicationRecord
  belongs_to :shop
  
  scope :own_shop, ->(shop_ids) {
    where(shop_id: shop_ids).order(order: :asc)
  }

  scope :is_using, ->(){
    where(is_using: true)
  }

  scope :is_not_empty, ->(){
    where.not(name: '')
  }
end
