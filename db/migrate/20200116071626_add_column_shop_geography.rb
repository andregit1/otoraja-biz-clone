class AddColumnShopGeography < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :latitude, :float, :after => :address, null:true
    add_column :shops, :longitude, :float, :after => :address, null:true
  end
end
