class AddIndexToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_index :customers, :tel
  end
end
