class AddStockAtCloseToStockControlls < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_controls, :stock_at_close, :float, :after => "difference"
  end
end
