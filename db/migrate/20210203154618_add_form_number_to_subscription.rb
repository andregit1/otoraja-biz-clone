class AddFormNumberToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :form_number, :string, :limit => 25
    change_column :subscriptions, :invoice_number, :string, :limit => 25
  end
end
