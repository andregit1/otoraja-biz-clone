class ChengeSendMessageBody < ActiveRecord::Migration[5.2]
  def up
    change_column :send_messages, :body, :text
  end

  def down 
    change_column :send_messages, :body, :string
  end
end
