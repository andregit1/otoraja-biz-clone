class AddColumnToSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :suppliers, :tel, :string, limit: 20, :after => 'name'
    add_column :suppliers, :address, :string, :after => 'name'
  end
end
