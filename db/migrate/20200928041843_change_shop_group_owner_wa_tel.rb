class ChangeShopGroupOwnerWaTel < ActiveRecord::Migration[5.2]
  def change
    change_column :shop_groups, :owner_wa_tel, :string, :limit => 255
  end
end
