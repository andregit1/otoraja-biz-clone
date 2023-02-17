class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :bengkel_id
      t.string :name
      t.string :tel
      t.string :tel2, null: true
      t.string :tel3, null: true
      t.string :address
      t.references :region, index: false
      t.references :province, index: false
      t.references :regency, index: false
      t.timestamps
    end
  end
end
