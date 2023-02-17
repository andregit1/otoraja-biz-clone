class AddShopConfigReceiptLayout < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :receipt_open_expiration_days, :integer, null: true, :after => :customer_remind_interval_days
    add_column :shop_configs, :receipt_layout, :string, null: true, :after => :customer_remind_interval_days
    add_column :shop_configs, :use_receipt, :boolean, null: false, :after => :customer_remind_interval_days

    ShopConfig.all.each do |shop_config|
      shop_config.update(
        use_receipt: false,
        receipt_layout: 'A4_portrait',
        receipt_open_expiration_days: 30,
      )
    end
    # Scooter Jam
    Shop.where(bengkel_id: ['100244', '100312']).each do |shop|
      config = ShopConfig.find_by(shop: shop)
      config.use_receipt = true
      config.receipt_layout = 'A4_portrait'
      config.receipt_open_expiration_days = 30
      config.save
    end
    # Sumber Jaya Moter
    Shop.where(bengkel_id: ['100240']).each do |shop|
      config = ShopConfig.find_by(shop: shop)
      config.use_receipt = true
      config.receipt_layout = 'cut_portrait'
      config.receipt_open_expiration_days = 30
      config.save
    end
    # ARYA Mandiri Motor
    Shop.where(bengkel_id: ['100223']).each do |shop|
      config = ShopConfig.find_by(shop: shop)
      config.use_receipt = true
      config.receipt_layout = 'cut_portrait'
      config.receipt_open_expiration_days = 30
      config.save
    end
  end
end
