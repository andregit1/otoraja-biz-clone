class AddRoundingToShopConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :rounding_direction, :string, :after => 'close_stock_time'
    add_column :shop_configs, :round_to, :int, :after => 'rounding_direction'
  end
end
