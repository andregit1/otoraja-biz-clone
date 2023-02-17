class ChangeDefaultFieldDeleteShopProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_products, :deleted_at, :datetime
  end
end
