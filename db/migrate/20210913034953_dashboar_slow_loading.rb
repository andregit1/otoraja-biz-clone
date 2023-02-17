class DashboarSlowLoading < ActiveRecord::Migration[5.2]
    def change
      add_index :maintenance_log_details, :unit_price
      add_index :maintenance_log_details, :maintenance_menu_id
      add_index :shop_products, :product_category_id
      add_index :checkins, :deleted
      add_index :checkins, :created_at
      add_index :maintenance_logs, :created_at
      add_index :maintenance_log_details, :created_at
      add_index :shop_staffs, :is_mechanic
      add_index :maintenance_mechanics, :created_at
    end
  end