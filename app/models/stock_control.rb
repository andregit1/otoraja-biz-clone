class StockControl < ApplicationRecord
  belongs_to :shop_product
  belongs_to :supplier, optional: true
  belongs_to :shop_invoice, optional: true
  #scope :own_stock, -> {
  #  joins(:stock_control)
  #}

  enum stock_action: {
    Arrival: 1,
    Loss: 2,
    Sale: 3,
    Return: 4
  }

  enum pay_type: {
    Cash: 1,
    Credit: 2,
    Other: 3,
  }

  def action
    StockControl.stock_actions.key(self.reason.to_i)
  end

  def payment
    StockControl.pay_types.key(self.payment_method.to_i) if self.action == 'Arrival'
  end

  scope :get_product_history, -> (id, start_date, end_date){
    find_by_sql("
    SELECT 
      r.id, 
      r.shop_product_id, 
      r.stock_at_close, 
      r.quantity,
      r.difference,
      r.date, 
      r.created_at, 
      r.reason,
      r.shop_invoice_id
    FROM (
      SELECT 
        sc1.id,
        sc1.shop_product_id,
        sc1.stock_at_close,
        sc1.quantity,
        sc1.difference,
        sc1.date,
        sc1.created_at,
        sc1.reason,
        sc1.shop_invoice_id
      FROM stock_controls sc1
      JOIN shop_invoices si1 
      ON sc1.shop_invoice_id = si1.id
      AND si1.status = #{ShopInvoice.statuses[:closed]}
      WHERE sc1.shop_product_id = #{id}
      UNION ALL
      SELECT 
        sc2.id,
        sc2.shop_product_id,
        sc2.stock_at_close,
        sc2.quantity,
        sc2.difference,
        sc2.date,
        sc2.created_at,
        sc2.reason,
        sc2.shop_invoice_id
      FROM stock_controls sc2
      WHERE sc2.shop_invoice_id IS NULL
      AND sc2.shop_product_id = #{id}
    ) as r
    WHERE r.date BETWEEN '#{start_date}' AND '#{end_date}'
    AND r.shop_product_id = #{id}
    ORDER BY r.created_at DESC;
    ")
  }
  
  class << self
    def get_reason(mode, difference)
      if mode.to_i == ShopPurchase.modes[:invoice]
          self.stock_actions[:Arrival]
      elsif mode.to_i == ShopPurchase.modes[:inventory]
        #check if the difference is positive or negative
        if difference.to_i > 0
          self.stock_actions[:Arrival]
        else
          self.stock_actions[:Loss]
        end
      end 
    end

    def new_reason_sale(date: Date.today)
      StockControl.new(
        date: date,
        reason: StockControl.stock_actions[:Sale],
      )
    end

    def new_reason_return(date: Date.today)
      StockControl.new(
        date: date,
        reason: StockControl.stock_actions[:Return],
      )
    end
  end
end
