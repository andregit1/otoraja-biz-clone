class AddColumnStockToShopConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :close_stock_time, :time, null: false, :after => 'receipt_open_expiration_days'
    add_column :shop_configs, :use_record_stock, :boolean, null: false, :after => 'receipt_open_expiration_days'
    add_column :shop_configs, :use_stock_notification, :boolean, null: false, :after => 'receipt_open_expiration_days'
    add_column :shop_configs, :stock_notification_destination, :string, limit: 20, :after => 'receipt_open_expiration_days'

    ShopConfig.update_all(close_stock_time: Time.local(2019, 1, 1, 14), use_record_stock: false, use_stock_notification: false)
  end
end
