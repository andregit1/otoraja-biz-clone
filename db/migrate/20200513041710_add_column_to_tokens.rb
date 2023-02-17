class AddColumnToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :customer_id, :bigint, :after => :checkin_id, null: true
    add_column :customers, :tmp_tel, :string, :limit => 20, :after => :tel, null: true
  end
end
