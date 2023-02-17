class AddGrossProfitToMaintenaceLogDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :gross_profit, :int, :after => 'sub_total_price'
  end
end
