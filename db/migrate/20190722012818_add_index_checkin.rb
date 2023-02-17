class AddIndexCheckin < ActiveRecord::Migration[5.2]
  def change
    add_index :checkins, :datetime
    add_index :checkins, :shop_id
    add_index :checkins, :customer_id
  end
end
