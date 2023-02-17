class RemoveShopStaffId < ActiveRecord::Migration[5.2]
  def up
    remove_column :shop_invoices, :shop_staff_id
  end

  def down
    add_column :shop_invoices, :shop_staff_id, :bigint, :after => :supplier_id
  end
end
