class AddMechanicIdToMaintenanceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :maintained_staff_id, :bigint, :after => 'updated_staff_id'
  end
end
