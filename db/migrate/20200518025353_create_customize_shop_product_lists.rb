class CreateCustomizeShopProductLists < ActiveRecord::Migration[5.2]
  def change
    create_table :customize_shop_product_lists, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.string :name, null: false
      t.integer :order, null: false
      t.boolean :can_add_all, null:false
      t.timestamps
    end
  end
end
