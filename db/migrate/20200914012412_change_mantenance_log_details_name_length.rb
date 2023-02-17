class ChangeMantenanceLogDetailsNameLength < ActiveRecord::Migration[5.2]
  def up
    change_column :maintenance_log_details, :name, :string, :limit=>510
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
