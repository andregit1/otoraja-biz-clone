class CreateShopVisitingReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_visiting_reasons, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.references :visiting_reason, index: false
      t.integer :display
      t.integer :order
      t.timestamps
    end
    
    reasons = VisitingReason.all
    Shop.all.each do |shop|
      reasons.each do |reason|
        ShopVisitingReason.create(
          shop: shop,
          visiting_reason: reason,
          display: 1,
          order: reason.id
        )
      end
      puts "Imported shop_visiting_reasons for Shop:#{shop.name}"
    end
  end
end
