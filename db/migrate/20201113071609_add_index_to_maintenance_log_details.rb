class AddIndexToMaintenanceLogDetails < ActiveRecord::Migration[5.2]
  def change
    add_index :maintenance_log_details, :shop_product_id
  end
end
