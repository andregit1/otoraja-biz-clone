class AddColumnToShopConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :customer_remind_interval_days, :integer, null: true, :after => :front_priority_display
    add_column :shop_configs, :use_customer_remind, :boolean, null: false, :after => :front_priority_display

    ShopConfig.update_all(use_customer_remind: false)

  end
end
