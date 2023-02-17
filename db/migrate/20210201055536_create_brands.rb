class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, length: 255, null: false
      t.timestamps
    end
  end
end
