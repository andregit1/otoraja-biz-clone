class AddAdminProductItemDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_products, :item_detail, :string, :after => 'name', null:true
  end
end
