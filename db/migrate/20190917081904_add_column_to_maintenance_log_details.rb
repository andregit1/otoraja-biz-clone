class AddColumnToMaintenanceLogDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :shop_product_id, :bigint, :after => :maintenance_menu_id, :null => true
    add_column :maintenance_log_details, :discount, :string,:limit => 45, :after => :wage, :null => true
    add_column :maintenance_log_details, :sub_total_price, :integer, :after => :unit_price, :null => true
  end
end
