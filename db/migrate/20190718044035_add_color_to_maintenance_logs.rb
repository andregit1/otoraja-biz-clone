class AddColorToMaintenanceLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :color, :string, :after => :reason
  end
end
