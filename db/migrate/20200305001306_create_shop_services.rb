class CreateShopServices < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_services do |t|
      t.references :shop, index: false
      t.references :service, index: false
      t.timestamps
    end

    create_table :services do |t|
      t.string :name, limit: 255, null: false
      t.timestamps
    end
  end
end
