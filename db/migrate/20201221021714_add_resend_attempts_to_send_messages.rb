class AddResendAttemptsToSendMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :send_messages, :resend_attempts, :integer, :after => "send_cost"
  end
end
