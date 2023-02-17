class AddColumnToMaintenanceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :reason, :string, :after => :displacement
  end
end
