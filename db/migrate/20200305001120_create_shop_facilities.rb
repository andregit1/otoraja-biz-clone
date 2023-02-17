class CreateShopFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_facilities do |t|
      t.references :shop, index: false
      t.references :facility, index: false
      t.timestamps
    end

    create_table :facilities do |t|
      t.string :name, limit: 255, null: false
      t.timestamps
    end
  end
end
