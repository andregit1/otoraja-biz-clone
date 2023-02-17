class AddWageToMaintenanceLogDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :wage, :int, :after => :unit_price
  end
end
