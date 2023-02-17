class MaintenanceLogDetail < ApplicationRecord
  include UserstampsConcern
  include StockManagementConcern

  belongs_to :maintenance_log
  belongs_to :shop_product, optional: true
  has_many :maintenance_log_detail_related_products, inverse_of: :maintenance_log_detail, dependent: :destroy
  has_many :maintenance_mechanics, inverse_of: :maintenance_log_detail, dependent: :delete_all
  has_many :product_reminder_logs
  has_many :shop_staffs, :through => :maintenance_mechanics
  accepts_nested_attributes_for :maintenance_mechanics, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :maintenance_log_detail_related_products, reject_if: :all_blank, allow_destroy: true

  validates :name, length: { maximum: 510 }
  validates :sub_total_price, length: { maximum: 10 }
  validates :shop_product_id, numericality: true, unless: -> { shop_product_id.blank? }
  validates :quantity, length: { maximum: 10 }, numericality: true, unless: -> { quantity.blank? }
  validates :unit_price, length: { maximum: 10 }, numericality: true, unless: -> { unit_price.blank? }
  validates :discount_amount, length: { maximum: 10 }, numericality: true, unless: -> { discount_amount.blank? }

  enum discount_type: { value: 1, rate: 2 }

  scope :aggregate_sales, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(`maintenance_log_details`.`sub_total_price`) AS total,
      DATE_FORMAT(CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      label
    SQL
  }

  scope :aggregate_gross_down_payment, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(`cash_flow_histories`.`cash_amount`) AS total, 
      DATE_FORMAT(CONVERT_TZ(`checkins`.`datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      maintenance_logs
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
      INNER JOIN
        `cash_flow_histories`
      ON  `cash_flow_histories`.`cashable_id` = `maintenance_logs`.`id`
    WHERE
      (
        `checkins`.`shop_id` = '#{shop_id}'
        AND CONVERT_TZ(`checkins`.`datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        AND `checkins`.`deleted` = false
        AND `cash_flow_histories`.`cash_type` = "DOWN_PAYMENT"
      )
    GROUP BY
      label
    SQL
  }

  scope :aggregate_gross_sales, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(`maintenance_log_details`.`unit_price`*`maintenance_log_details`.`quantity`) AS total,
      DATE_FORMAT(CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      label
    SQL
  }

  scope :aggregate_gross_profit, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(CASE WHEN `maintenance_log_details`.`gross_profit` IS NULL
          THEN `maintenance_log_details`.`unit_price`*`maintenance_log_details`.`quantity`
          ELSE `maintenance_log_details`.`gross_profit`
          END
          ) AS total,
      DATE_FORMAT(CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      label
    SQL
  }

  scope :aggregate_data, ->(shop_id, start_datetime, end_datetime, format, field) {
    find_by_sql(<<-SQL)
    SELECT
      SUM(`maintenance_log_details`.`#{field}`) AS total,
      DATE_FORMAT(CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      label
    SQL
  }

  scope :aggregate_sales_details, ->(shop_id, start_datetime, end_datetime) {
    find_by_sql(<<-SQL)
    SELECT
      `product_categories`.`id` as id,
      SUM(`maintenance_log_details`.`sub_total_price`) AS sales,
      SUM(`maintenance_log_details`.`quantity`) AS sold,
      IFNULL(SUM(maintenance_log_details.gross_profit),SUM(maintenance_log_details.sub_total_price)) as gross_profit, 
      IFNULL(SUM(maintenance_log_details.discount_amount),0) as discount_amount,
      IFNULL(SUM(maintenance_log_details.sub_total_price)+SUM(maintenance_log_details.discount_amount)-SUM(maintenance_log_details.gross_profit),0) as cogs,
      IFNULL(`product_categories`.`name`, 'Manual Input') as name
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
      LEFT JOIN
        `shop_products`
      ON  `shop_products`.`id` = `maintenance_log_details`.`shop_product_id`
      LEFT JOIN
        `product_categories`
      ON  `product_categories`.`id` = `shop_products`.`product_category_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `maintenance_log_details`.`maintenance_menu_id` IS NULL
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      id, name
    ORDER BY
      sales DESC
    SQL
  }

  scope :aggregate_sales_details_by_product, ->(shop_id, start_datetime, end_datetime) {
    find_by_sql(<<-SQL)
    SELECT
      `product_categories`.`id` AS id,
      SUM(`maintenance_log_details`.`unit_price`*`maintenance_log_details`.`quantity`) AS sales,
      SUM(`maintenance_log_details`.`quantity`) AS sold,
      SUM(IF(maintenance_log_details.gross_profit IS NOT NULL, (maintenance_log_details.gross_profit-IFNULL(maintenance_log_details.discount_amount,0)), maintenance_log_details.sub_total_price)) AS gross_profit, 
      SUM(`maintenance_log_details`.`discount_amount`) AS discount,
      SUM(IF(maintenance_log_details.gross_profit IS NOT NULL, (maintenance_log_details.sub_total_price+IFNULL(maintenance_log_details.discount_amount,0)-maintenance_log_details.gross_profit),0)) AS cogs,
      IFNULL(`product_categories`.`name`, 'Manual Input') AS category,
      REPLACE(IFNULL(`maintenance_log_details`.`name`, 'Manual Input'), '\"', '') AS name
    FROM
      maintenance_log_details
      INNER JOIN
        `maintenance_logs`
      ON  `maintenance_logs`.`id` = `maintenance_log_details`.`maintenance_log_id`
      INNER JOIN
        `checkins`
      ON  `checkins`.`id` = `maintenance_logs`.`checkin_id`
      LEFT JOIN
        `shop_products`
      ON  `shop_products`.`id` = `maintenance_log_details`.`shop_product_id`
      LEFT JOIN
        `product_categories`
      ON  `product_categories`.`id` = `shop_products`.`product_category_id`
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `maintenance_log_details`.`maintenance_menu_id` IS NULL
    AND `checkins`.`deleted` = false
    AND `checkins`.`is_checkout` = true
    GROUP BY
      id, name, category
    ORDER BY
      sales DESC
    SQL
  }

  scope :get_profit_by_product, ->(shop_id, start_datetime, end_datetime, format){
    find_by_sql(<<-SQL
      select 
        mld.shop_product_id, 
        mld.name, 
        IFNULL(SUM(mld.gross_profit),SUM(mld.sub_total_price)) as gross_profit, 
        IFNULL(SUM(mld.discount_amount),0) as discount_amount,
        IFNULL(SUM(mld.sub_total_price)+SUM(mld.discount_amount)-SUM(mld.gross_profit),0) as cogs,
        DATE_FORMAT(CONVERT_TZ(c.checkout_datetime, 'UTC', 'ASIA/JAKARTA'), '#{format}') as label
      from maintenance_log_details mld
        join shop_products sp 
        on mld.shop_product_id = sp.id
        join maintenance_logs ml
        on ml.id = mld.maintenance_log_id
        join checkins c 
        on c.id = ml.checkin_id
        join shops s
        on s.id = c.shop_id
      where s.id = #{shop_id}
      and CONVERT_TZ(c.checkout_datetime, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
      AND c.deleted = false
      AND c.is_checkout = true
      group by 
        mld.shop_product_id, 
        mld.name,
        label
      order by
        gross_profit DESC
    SQL
    )
  }

  scope :transaction_summary, -> (shop_id, start_date, end_date){
    find_by_sql("
    SELECT
      COUNT(DISTINCT ml.id) AS total_transactions,
      COUNT(DISTINCT CASE 
          WHEN c.is_checkout = true
          THEN ml.id
          END) AS total_transactions_done,
      COALESCE(SUM(CASE 
          WHEN c.is_checkout = true
          THEN mld.sub_total_price
          END), 0) AS total_price_done,
      COALESCE(COUNT(DISTINCT CASE 
          WHEN c.is_checkout = false
          THEN ml.id
          END), 0) AS total_transactions_not_done,
      COALESCE(SUM(CASE 
          WHEN c.is_checkout = false
          THEN mld.sub_total_price
          END), 0) AS total_price_not_done
    FROM
        maintenance_log_details mld
        INNER JOIN
        maintenance_logs ml 
        ON  ml.id = mld.maintenance_log_id
        INNER JOIN
        checkins c 
        ON  c.id = ml.checkin_id
      WHERE
        ( 
          c.shop_id = '#{shop_id}' 
          AND (c.checkout_datetime BETWEEN '#{start_date}' AND '#{end_date}') 
          AND c.deleted = false 
          AND c.is_checkout = true 
        )
      OR 
        ( 
          c.shop_id = '#{shop_id}' 
          AND (c.datetime <='#{end_date}') 
          AND c.deleted = false 
          AND c.is_checkout = false
        );
    ")
  }

  def subtotal
    unit_price = self.unit_price || 0
    quantity = self.quantity || 0
    discount_amount = self.discount_amount || 0
    unit_price * quantity - discount_amount
  end

  def view_discount_amount
    (self.discount_amount >= 0 ? '-' : '+') + self.discount_amount.abs.to_s(:delimited, delimiter: '.')
  end

  def is_service?
    self.shop_product.product_category.product_class.name === "SERVICE"
  end

end
