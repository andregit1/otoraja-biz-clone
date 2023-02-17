class Checkin < ApplicationRecord
  include UserstampsConcern

  belongs_to :customer
  belongs_to :shop
  has_one :maintenance_log
  has_one :questionnaire
  has_many :token
  has_one :customer_reminder_log

  has_one_attached :receipt

  scope :own_shop, ->(shop_ids) {
    where(shop_id: shop_ids)
  }

  scope :exclude_system_created, ->(){
    where.not(created_staff_id: 0)
  }

  def deleted?
    self.deleted == true
  end

  def checkout?
    self.is_checkout?
  end

  def checkin_no
    "#{self.shop.bengkel_id}-#{self.datetime.strftime('%Y%m%d')}-#{format('%07d', self.id)}"
  end

  def is_sendable_receipt_sms
    # 店舗設定でレシートが有効かつ、電話番号が設定されている場合、送信可能
    self.shop.shop_config.use_receipt && self.customer.tel.present?
  end

  def is_sendable_receipt_wa
    # 店舗設定でレシートが有効かつ、電話番号が設定されている場合、送信可能
    self.shop.shop_config.use_receipt && self.customer.wa_tel.present?
  end

  def deleted_checkin
    return if self.deleted?
    self.deleted = true
    self.save!
    self.maintenance_log.maintenance_log_details.each do | item |
      shop_product = item.shop_product
      shop_product.return_stock(item.quantity)
      if shop_product.has_inclusion_product?
        shop_product.packaging_product_relations_packaging.each do |inclusion_product|
          inclusion_product.inclusion_product.return_stock(inclusion_product.quantity)
        end
      end
    end
  end

  def restore_checkin
    return unless self.deleted?
    self.deleted = false
    self.save!
    self.maintenance_log.maintenance_log_details.each do | item |
      shop_product = item.shop_product
      shop_product.sale_stock(item.quantity)
      if shop_product.has_inclusion_product?
        shop_product.packaging_product_relations_packaging.each do |inclusion_product|
          inclusion_product.inclusion_product.sale_stock(inclusion_product.quantity)
        end
      end
    end
  end

  def get_status
    if self.is_checkout && !self.deleted
      return 'SELESAI'
    elsif !self.is_checkout && !self.deleted
      return 'DIPROSES'
    elsif self.deleted
      return 'VOID'
    end
  end

  # send_message(サンキュー)未登録 & チェックアウト済み & 電話番号存在 & DM送信許可
  scope :need_register_ty_message, -> do
    where.not(<<-SQL).where.not(checkout_datetime: nil).joins(:customer).where.not(customers: {tel: nil}).where(customers: {send_dm: true})
    (
      EXISTS (
        SELECT
          `send_messages`.*
        FROM
          `send_messages`
          INNER JOIN
            `questionnaires`
          ON  `questionnaires`.`send_message_id` = `send_messages`.`id`
        WHERE
          `send_messages`.`send_purpose` = #{SendMessage.send_purposes[:ty]}
        AND `questionnaires`.`checkin_id` = `checkins`.`id`
      )
    )
    SQL
  end

  scope :aggregate_visitors, ->(shop_id, start_datetime, end_datetime, format) {
    find_by_sql(<<-SQL)
    SELECT
      COUNT(*) as total,
      DATE_FORMAT(CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA'), '#{format}') AS label
    FROM
      checkins
    WHERE
      `checkins`.`shop_id` = '#{shop_id}'
    AND CONVERT_TZ(`checkins`.`checkout_datetime`, 'UTC', 'ASIA/JAKARTA') BETWEEN '#{start_datetime}' AND '#{end_datetime}'
    AND `checkins`.`deleted` = false
    AND `checkins`.`created_staff_id` != 0
    AND `checkins`.`is_checkout` = true
    GROUP BY
      label
    SQL
  }

  # 御用聞きリマインド送信対象検索
  # ・顧客の電話番号が存在する
  # ・DM送信許可
  # ・最終チェックアウト日からリマインド期間が経過している
  # ・リマインド期間の間にその店舗に対して御用聞きリマインドを送信していない
  # ・店舗設定でリマインド許可&リマインド期間設定済み
  scope :need_customer_remind, -> {
    find_by_sql(<<-SQL)
    SELECT
      max(checkins.id) AS last_checkout_id,
      max(checkins.checkout_datetime) AS last_checkout_datetime,
      checkins.customer_id,
      checkins.shop_id
    FROM
      checkins
      INNER JOIN
        customers
      ON  checkins.customer_id = customers.id
      INNER JOIN
        shops
      ON  checkins.shop_id = shops.id
      INNER JOIN
        shop_configs
      ON  shop_configs.shop_id = shops.id
    WHERE
      checkout_datetime IS NOT NULL
    AND (customers.tel IS NOT NULL AND customers.tel != '')
    AND
      customers.send_dm = TRUE
    AND
      shop_configs.customer_remind_interval_days IS NOT NULL
    AND
      shop_configs.use_customer_remind = TRUE
    AND 
      DATE_ADD( CAST(`checkout_datetime` AS DATE), interval shop_configs.customer_remind_interval_days DAY ) <= CURDATE()
    AND NOT EXISTS (
      SELECT 1
      FROM 
        customer_reminder_logs
        INNER JOIN
          send_messages
        ON  customer_reminder_logs.send_message_id = send_messages.id
        INNER JOIN
          checkins AS logs_checkins
        ON  customer_reminder_logs.checkin_id = logs_checkins.id
      WHERE 
        customer_reminder_logs.customer_id = customers.id
      AND
        checkins.shop_id = logs_checkins.shop_id
      AND 
        send_messages.send_purpose = #{SendMessage.send_purposes[:customer_remind]}
      AND 
        send_messages.sent_at BETWEEN checkins.checkout_datetime AND NOW()
    )
    GROUP BY
      checkins.shop_id,
      checkins.customer_id
    SQL
  }
end
