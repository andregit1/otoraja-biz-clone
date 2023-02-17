class AddIndexToOwnedbike < ActiveRecord::Migration[5.2]
  def change
    add_index :owned_bikes, [:number_plate_area, :number_plate_number, :number_plate_pref], :name => 'index_owned_bikes_on_number_plate'
  end
end
