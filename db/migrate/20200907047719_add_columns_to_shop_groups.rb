class AddColumnsToShopGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_groups, :active_plan, :int
    add_column :shop_groups, :expiration_date, :datetime
    add_column :shop_groups, :virtual_bank_no, :string
    add_column :shop_groups, :owner_wa_tel, :int
  end
end
