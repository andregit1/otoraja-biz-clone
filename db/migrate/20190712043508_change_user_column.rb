class ChangeUserColumn < ActiveRecord::Migration[5.2]
  def up
    change_column_null :users, :encrypted_password, true
    remove_column :users, :user_type
    remove_column :users, :email
    add_column :users, :mechanic_grade, :integer, null: true, :after => :role
    add_column :users, :status, :string, :limit => 10, null: false, :after => :role
    User.where(status: '').each do |user|
      user.status = 'enabled'
      user.save
    end
  end

  def down 
    change_column_null :users, :encrypted_password, false
    add_column :users, :user_type, :string, :limit => 20, null: false, :after => :name
    add_column :users, :email, :string, null: false, default: "", :after => :role
    remove_column :users, :mechanic_grade
    remove_column :users, :status
  end
end
