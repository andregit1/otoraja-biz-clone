class CreateCustomizeShopProductDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :customize_shop_product_details, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :customize_shop_product_list, index: false
      t.references :shop_product, index: false
      t.integer :order, null: false
      t.timestamps
    end
  end
end
