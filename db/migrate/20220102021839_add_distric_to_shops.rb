    class AddDistricToShops < ActiveRecord::Migration[5.2]
  def change
    add_reference :shops, :distric, index: true
  end
end
