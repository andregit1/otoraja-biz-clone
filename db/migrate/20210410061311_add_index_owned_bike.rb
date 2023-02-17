class AddIndexOwnedBike < ActiveRecord::Migration[5.2]
  def change
    add_index :owned_bikes, :customer_id
  end
end
