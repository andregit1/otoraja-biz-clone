class AddSubjectColumnToSendMessage < ActiveRecord::Migration[5.2]
  def up
    change_column :send_messages, :from, :string, :limit => 50
    change_column :send_messages, :to, :string, :limit => 50
    add_column :send_messages, :subject, :string, :after => 'to'
  end

  def down
    remove_column :send_messages, :subject
    change_column :send_messages, :from, :string, :limit => 20
    change_column :send_messages, :to, :string, :limit => 20
  end
end
