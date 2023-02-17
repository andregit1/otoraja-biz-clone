class AddVerificationRequest < ActiveRecord::Migration[5.2]
  def up
    add_column :customers, :token_request_count, :integer, default: 0
    add_column :customers, :token_locked_at, :datetime
  end

  def down
    remove_column :customers, :token_request_count, :integer, default: 0
    remove_column :customers, :token_locked_at, :datetime
  end
end
