class AddIndexToShop < ActiveRecord::Migration[5.2]
  def change
    add_index :shops, :bengkel_id, :unique => true
  end
end
