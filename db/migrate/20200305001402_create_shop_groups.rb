class CreateShopGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_groups do |t|
      t.string :name, limit: 255, null: false
      t.string :owner_name, limit: 255
      t.integer :owner_gender
      t.string :owner_tel
      t.string :owner_tel2
      t.string :owner_email, limit: 100
      t.integer :founding_year
      t.boolean :is_chain_shop
      t.timestamps
    end

    add_column :shops, :shop_group_id, :bigint, :after => :bengkel_id
  end
end
