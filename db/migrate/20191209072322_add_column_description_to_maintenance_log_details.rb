class AddColumnDescriptionToMaintenanceLogDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :description, :string, :after => 'name', null:true
  end
end
