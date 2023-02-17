class ShopStaff < ApplicationRecord 
  belongs_to :shop
  has_many :maintenance_mechanics

  validates :name, presence: true, length: { maximum: 45 }


  scope :own_shop, ->(shop_ids) {
    joins(:shop).where(shops: { id: shop_ids } )
  }

  scope :active_mechanics, -> {
    where(is_mechanic: true, active: true).order(mechanic_grade: :desc)
  }

  scope :active_front_staffs, -> {
    where(is_front_staff: true, active: true)
  }
  
  scope :active_mechanics_by_name, -> {
    where(is_mechanic: true, active: true).order(name: :asc)
  }

  scope :get_maintenance_for_range, ->(staff, start_datetime, end_datetime){
    staff.maintenance_mechanics.where("created_at between ? and ?", start_datetime, end_datetime)
  }

  scope :get_maintenance_for_range_transaction, ->(shop_id, start_datetime, end_datetime) {
    find_by_sql(<<-SQL)
    SELECT 
      mm.shop_staff_id,
      mld.quantity,
      mld.sub_total_price,
      pc2.name as type,
      c.checkout_datetime,
      c.id,
      mld.name
    FROM checkins c
    LEFT JOIN maintenance_logs ml on ml.checkin_id  = c.id
    LEFT JOIN maintenance_log_details mld on mld.maintenance_log_id  = ml.id
    LEFT JOIN maintenance_mechanics mm  on mm.maintenance_log_detail_id  = mld.id
    LEFT JOIN shop_products sp on mld.shop_product_id = sp.id
    LEFT JOIN product_categories pc on sp.product_category_id = pc.id
    LEFT JOIN product_classes pc2 on pc2.id = pc.product_class_id
    WHERE (c.checkout_datetime BETWEEN '#{start_datetime}' AND '#{end_datetime}')
    AND (c.deleted = 0 AND c.is_checkout = 1 AND mld.unit_price != 0 AND c.shop_id = '#{shop_id}' );
    SQL
  }

  class << self
    def aggregate_mechanic_sales_details(shop_id, start_datetime, end_datetime)
      result = []
      scopedRecords = ShopStaff.get_maintenance_for_range_transaction(shop_id, start_datetime, end_datetime)
      shopStaff = ShopStaff.own_shop(shop_id).active_mechanics_by_name;

      no_mechanic = scopedRecords.select { |record| record.shop_staff_id.nil? }
      total = 0
      products = 0
      product_transactions = 0
      services = 0
      service_transactions = 0

      if no_mechanic.present?
        no_mechanic.each do |item| 
          if item.type == "SERVICE"
            services += item.quantity
            service_transactions += item.sub_total_price
          else
            products += item.quantity
            product_transactions += item.sub_total_price
          end
          total += item.sub_total_price
        end

        result << {
          mechanic: {id: 0, name: "Tanpa Mekanik"},
          total: total,
          products: products,
          product_transactions: product_transactions,
          services: services,
          service_transactions: service_transactions
        }
      else
        result << {
          mechanic: {id: 0, name: "Tanpa Mekanik"},
          total: 0,
          products: 0,
          product_transactions: 0,
          services: 0,
          service_transactions: 0
        }
      end

      for staff in shopStaff do
        total = 0
        products = 0
        product_transactions = 0
        services = 0
        service_transactions = 0

        for item in scopedRecords.select { |record| record.shop_staff_id == staff.id }
          if item.type == "SERVICE"
            services += item.quantity
            service_transactions += item.sub_total_price
          else
            products += item.quantity
            product_transactions += item.sub_total_price
          end
          total = total + item.sub_total_price
        end

        result << {
          mechanic: staff,
          total: total,
          products: products,
          product_transactions: product_transactions,
          services: services,
          service_transactions: service_transactions
        }
      end
      result
    end

    def aggregate_mechanic_sales_recap(shop_id, start_datetime, end_datetime)
      result = []
      scopedRecords = ShopStaff.get_maintenance_for_range_transaction(shop_id, start_datetime, end_datetime)
      shopStaff = ShopStaff.own_shop(shop_id).active_mechanics_by_name;
      
      for staff in shopStaff do
        total = 0
        products = 0
        product_transactions = 0
        services = 0
        service_transactions = 0

        for item in scopedRecords.select { |record| record.shop_staff_id == staff.id }
          if item.type == "SERVICE"
            services += item.quantity
            service_transactions += item.sub_total_price
          else
            products += item.quantity
            product_transactions += item.sub_total_price
          end
          total = total + item.sub_total_price
        end

        result << {
          mechanic: staff,
          total: total,
          products: products,
          product_transactions: product_transactions,
          services: services,
          service_transactions: service_transactions
        }
      end
      result
    end

    def aggregate_mechanic_attendence(shop_id, start_datetime, end_datetime)

      shopStaff = ShopStaff.own_shop(shop_id).active_mechanics_by_name;
      result = []

      for staff in shopStaff do
        workRecords = ShopStaff.get_maintenance_for_range_transaction(staff.id,start_datetime, end_datetime)
        days = 0
        workRecords.each do |item|
          days = days + 1
        end
        result << {
          mechanic: staff,
          daysWorked: days
        }
      end
      result
    end

    def aggregate_mechanic_transactions(shop_id, start_datetime, end_datetime)

      shop_staff = ShopStaff.own_shop(shop_id).active_mechanics_by_name;
      result = []

      for staff in shop_staff do
        maintenace_logs = MaintenanceLog.get_mechanic_transactions_for_range(staff.id, start_datetime, end_datetime)
        count = 0
        maintenace_logs.each do |item|
          unless item.checkin.deleted? && !item.checkin.is_checkout
            count = count + 1
          end
        end
        result << {
          mechanic: staff,
          transactions: count
        }
      end
      result
    end

    def current_staff
      @current_staff
    end

    def current_staff=(value)
      @current_staff = value
    end

  end

  def is_front_staff?
    self.is_front_staff
  end

  def is_mechanic?
    self.is_mechanic
  end

  def active?
    self.active
  end

end

