class AddParametersToSendMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :send_messages, :parameters, :string, :after => "resend_attempts"
  end
end
