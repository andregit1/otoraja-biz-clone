class AddColumnToCustomers < ActiveRecord::Migration[5.2]
  def up
    add_column :customers, :tmp_email, :string, :limit => 100, :after => :email, null: true
  end

  def down
    remove_column :customers, :tmp_email
  end
end
