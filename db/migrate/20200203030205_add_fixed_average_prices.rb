class AddFixedAveragePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :fixed_average_prices, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop_product, index: false
      t.bigint :average_price
      t.timestamps
    end
  end
end
