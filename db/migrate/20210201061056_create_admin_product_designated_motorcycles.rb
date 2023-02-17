class CreateAdminProductDesignatedMotorcycles < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_product_designated_motorcycles, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :bike_model, index: false
      t.references :admin_product, index: false
      t.timestamps
    end
  end
end
