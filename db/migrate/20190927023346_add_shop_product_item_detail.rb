class AddShopProductItemDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_products, :item_detail, :string, :after => 'shop_alias_name', null:true
  end
end
