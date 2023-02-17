class ShopInvoice < ApplicationRecord
  belongs_to :shop
  has_many :stock_controls, dependent: :destroy
  belongs_to :supplier, -> { with_discarded }, optional: true
  has_many :shop_products, through: :stock_controls

  scope :own_shop, ->(shop_ids) {
    where(shop_id: shop_ids)
  }

  enum sort: {latest: 0, oldest: 1}

  enum status: {open: 0, closed: 1}

  class << self
    def find_by_mode(mode)
      if mode.to_i == ShopPurchase.modes[:invoice]
        #returnを使わないと結果がnil
        return ShopInvoice.where(is_inventory: false)
      end
      if mode.to_i == ShopPurchase.modes[:inventory]
        return ShopInvoice.where(is_inventory: true)
      end
    end

    def sort_condition
      {
        latest: 'shop_invoices.updated_at desc',
        oldest: 'shop_invoices.updated_at asc',
      }
    end
  end

  def find_inventory_or_invoice
    return OpenStruct.new(is_invoice: !self.is_inventory, is_inventory: self.is_inventory)
  end
end
