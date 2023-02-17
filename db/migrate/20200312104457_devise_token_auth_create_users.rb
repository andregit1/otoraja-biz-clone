class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :provider, :string, :null => false, :default => "user_id"
    add_column :users, :uid, :string, :null => false, :default => ""
    add_column :users, :tokens, :text

    ActiveRecord::Base.transaction do
      User.all.each do |user|
        user.update(uid: user.user_id)
      end
    end

    add_index :users, [:uid, :provider], unique: true
  end

  def down
    remove_index :table_name, [:uid, :provider]
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :tokens
  end
end
