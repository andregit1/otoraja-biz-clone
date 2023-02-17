class AddAdditionalInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_otoraja_biz, :boolean
    add_column :users, :is_otoraja_bp, :boolean
    add_column :users, :referral, :string
  end
end
