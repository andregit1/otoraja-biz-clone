class ShopExpense < ApplicationRecord
  belongs_to :supplier, -> { with_discarded }
  belongs_to :shop

  default_scope {
    where(deleted_at: nil)
  }
  scope :own_shop, ->(shops) {
    where(shop: shops)
  }

  scope :aggregate_gross_expenses, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(`shop_expenses`.`value`) AS total,
      DATE_FORMAT(CONVERT_TZ(`shop_expenses`.`expense_date`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      shop_expenses
    WHERE
      `shop_expenses`.`shop_id` = '#{shop_id}'
    AND `shop_expenses`.`deleted_at` is null
    AND CONVERT_TZ(`shop_expenses`.`expense_date`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    GROUP BY
      label
    SQL
  }

  def discard!
    self.deleted_at = Date.today
    self.save
  end
end
