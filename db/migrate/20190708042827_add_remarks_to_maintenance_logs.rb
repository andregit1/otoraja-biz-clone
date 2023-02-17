class AddRemarksToMaintenanceLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :remarks, :text
  end
end
