class RemoveShopProductName < ActiveRecord::Migration[5.2]
  def up
    remove_column :shop_products, :name
  end

  def down 
    add_column :shop_products, :name, :string
  end
end
