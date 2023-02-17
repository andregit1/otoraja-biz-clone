class AddDiscardedAtToSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :suppliers, :deleted_at, :datetime
    add_index :suppliers, :deleted_at
  end
end
