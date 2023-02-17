class AddColumnAdminProductsAttribute < ActiveRecord::Migration[5.2]
  def change
    add_reference :admin_products, :brand, foreign_key: false
    add_reference :admin_products, :variant, foreign_key: false
    add_reference :admin_products, :tech_spec, foreign_key: false
  end
end
