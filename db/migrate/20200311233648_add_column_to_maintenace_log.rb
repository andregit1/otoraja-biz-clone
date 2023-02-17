class AddColumnToMaintenaceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :amount_paid, :int
    add_column :maintenance_logs, :adjustment, :int
  end
end
