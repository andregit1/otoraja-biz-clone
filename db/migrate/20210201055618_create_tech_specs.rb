class CreateTechSpecs < ActiveRecord::Migration[5.2]
  def change
    create_table :tech_specs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :product_category, index: false
      t.string :name, length: 255, null: false
      t.timestamps
    end
  end
end
