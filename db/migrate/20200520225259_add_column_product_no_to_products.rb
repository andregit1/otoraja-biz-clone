class AddColumnProductNoToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_products, :product_no, :string, :after => 'product_category_id'
    add_column :shop_products, :product_no, :string, :after => 'admin_product_id'
    add_column :maintenance_log_details, :product_no, :string, :after => 'shop_product_id'
    add_column :maintenance_log_detail_related_products, :product_no, :string, :after => 'shop_product_id'
  end
end
