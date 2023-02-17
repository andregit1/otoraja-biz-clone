class AddColumnCcToSendMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :send_messages, :cc, :text, :after => 'to'
  end
end
