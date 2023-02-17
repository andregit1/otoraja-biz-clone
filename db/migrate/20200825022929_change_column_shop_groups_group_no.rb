class ChangeColumnShopGroupsGroupNo < ActiveRecord::Migration[5.2]
  def change
    change_column :shop_groups, :group_no, :string, :limit => 20, :null => false
    ShopGroup.all.each do |shop_group|
      shop_group.update(
        group_no: format("%0#{6}d", shop_group.group_no)
      )
    end
  end
end
