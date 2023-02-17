class AddDifferenceToStockControll < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_controls, :difference, :float, :after => 'payment_method'
  end
end
