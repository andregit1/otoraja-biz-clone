class CreateMaintenanceLogDetailRelatedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenance_log_detail_related_products, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :maintenance_log_detail, index: false
      t.references :shop_product, index: false
      t.string :category_name
      t.string :item_name
      t.string :item_detail
      t.float :quantity
      t.timestamps
    end
  end
end
