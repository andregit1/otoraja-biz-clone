class AddSubscriptionidInTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :subscription_id, :bigint, :after => "customer_id"
  end
end
