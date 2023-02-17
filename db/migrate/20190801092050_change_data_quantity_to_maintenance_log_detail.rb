class ChangeDataQuantityToMaintenanceLogDetail < ActiveRecord::Migration[5.2]
  def up
    change_column :maintenance_log_details, :quantity, :float
  end

  def down
    change_column :maintenance_log_details, :quantity, :int
  end
end