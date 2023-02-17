class CreatePackagingProductRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :packaging_product_relations, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.belongs_to :packaging_product, references: :shop_product, index: false
      t.belongs_to :inclusion_product, references: :shop_product, index: false
      t.float :quantity, null: true
      t.timestamps
    end
  end
end
