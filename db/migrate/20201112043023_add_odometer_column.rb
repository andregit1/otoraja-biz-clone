class AddOdometerColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :bikes, :odometer_updated_at, :datetime, :after => "color"
    add_column :bikes, :odometer, :integer, :after => "color"

    add_column :maintenance_logs, :odometer_updated_at, :datetime, :after => "color"
    add_column :maintenance_logs, :odometer, :integer, :after => "color"
    add_column :maintenance_logs, :previous_odometer_updated_at, :datetime, :after => "color"
    add_column :maintenance_logs, :previous_odometer, :integer, :after => "color"
  end
end
