class MaintenanceLogPaymentMethod < ApplicationRecord
  include UserstampsConcern

  belongs_to :maintenance_log, optional: true
  belongs_to :payment_method

  class << self

    def aggregate_sales_by_payment_type(shop_id, start_datetime, end_datetime)

      find_by_sql(<<-SQL)
        SELECT 
          IV.name
          ,SUM(I.amount) as amount 
        FROM maintenance_log_payment_methods I
          INNER JOIN 
            maintenance_logs II
          ON II.id = I.maintenance_log_id
          INNER JOIN 
            checkins III
          ON III.id = II.checkin_id 
          INNER JOIN
            payment_methods IV
          ON IV.id = I.payment_method_id
        WHERE III.shop_id = '#{shop_id}'
        AND CONVERT_TZ(III.checkout_datetime, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        AND III.deleted = false
        AND III.is_checkout = true
        GROUP BY 
          I.payment_method_id
      SQL
    end

  end

end


