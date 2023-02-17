class AddMaintenanceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :name, :string, :limit => 45, :after => :checkin_id
  end
end
