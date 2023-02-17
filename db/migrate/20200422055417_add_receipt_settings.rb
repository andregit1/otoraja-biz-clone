class AddReceiptSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :receipt_type, :int, :after => "send_dm" 
    add_column :customers, :send_type, :int, :after => "receipt_type" 
    add_column :customers, :wa_tel, :string, :limit => 20, :after => "send_type" 
  end
end
