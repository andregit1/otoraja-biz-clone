class ChangeColumnCustomerTel < ActiveRecord::Migration[5.2]
  def up
    change_column :customers, :tel, :string, limit: 20
  end
  def down 
    change_column :customers, :tel, :long
  end
end
