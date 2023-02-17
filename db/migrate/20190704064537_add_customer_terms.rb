class AddCustomerTerms < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :terms_agreed_at, :datetime, null: true, :after => :send_dm
  end
end
