class CreateTableShopExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_expenses do |t|
      t.integer :value
      t.string :no_ref
      t.text :description 
      t.datetime :expense_date
      t.datetime :deleted_at
      t.references :supplier, index: true
      t.references :shop, index: true
      t.timestamps
    end
  end
end
