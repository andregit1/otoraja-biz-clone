class AddColumnRemarksToMaintenanceLogDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :remarks, :text, :after => 'discount_amount'
  end
end
