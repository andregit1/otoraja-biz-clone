class AddGroupNoToShopGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_groups, :group_no, :integer, :after => 'id' 
    add_column :shop_groups, :subscriber_type, :integer, :after => 'is_chain_shop'
  end
end
