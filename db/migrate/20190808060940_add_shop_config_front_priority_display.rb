class AddShopConfigFrontPriorityDisplay < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :front_priority_display, :string, null: false, :after => :message_send_time
    # デフォルトはナンバープレート
    ShopConfig.all.each do |config|
      config.front_priority_display = 'number_plate'
      config.save
    end
    # Scooter Jamだけ電話番号表示
    Shop.where(bengkel_id: ['100244', '100312']).each do |shop|
      config = ShopConfig.find_by(shop: shop)
      unless config.nil?
        config.front_priority_display = 'phone_number'
        config.save
      end
    end
  end
end
