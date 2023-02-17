class AddInitialSetupShopField < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :shop_groups, :initial_setup
      remove_column :shop_groups, :initial_setup
    end
    add_column :shops, :initial_setup, :boolean, :default => true
  end
end
