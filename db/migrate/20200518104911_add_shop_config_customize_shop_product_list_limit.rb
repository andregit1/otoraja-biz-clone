class AddShopConfigCustomizeShopProductListLimit < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_configs, :num_of_products_in_custom_list, :int, null: false, :after => 'round_to'
    add_column :shop_configs, :num_of_custom_list, :int, null: false, :after => 'round_to'
    ShopConfig.all.each do |shop_config|
      shop_config.update(
        num_of_products_in_custom_list: 15,
        num_of_custom_list: 15,
      )
    end
  end
end
