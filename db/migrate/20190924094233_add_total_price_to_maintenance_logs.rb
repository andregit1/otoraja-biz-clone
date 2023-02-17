class AddTotalPriceToMaintenanceLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :total_price, :int
  end
end
