class CreateShopConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_configs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.integer :questionnaire_expiration_days, null: false, default: 3
      t.time :message_send_time, null: false, default: Time.local(2019, 1, 1, 14)
      t.timestamps
    end
    # ========== Shop Config ==========
    Shop.all.each do |shop|
      ShopConfig.create(shop: shop)
    end
  end
end
