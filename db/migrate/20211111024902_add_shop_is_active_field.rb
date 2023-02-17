class AddShopIsActiveField < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :is_reactivated, :boolean, :default => false
  end
end