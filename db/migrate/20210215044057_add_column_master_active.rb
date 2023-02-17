class AddColumnMasterActive < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :active, :boolean, :null => false, :default => true, :after => "name"
    add_column :variants, :active, :boolean, :null => false, :default => true, :after => "name"
    add_column :tech_specs, :active, :boolean, :null => false, :default => true, :after => "name"
  end
end
