class AddColumnToSendMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :send_messages, :send_cost, :float, :after => :sent_at
    add_column :send_messages, :send_status, :string, :after => :sent_at
    add_column :send_messages, :query_id, :string, :after => :sent_at
  end
end
