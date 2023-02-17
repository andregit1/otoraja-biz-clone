class AddPasswordUpdatedAtColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_updated_at, :datetime
  end
end
