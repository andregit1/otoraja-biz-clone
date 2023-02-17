class AddIndexToShopProductAndQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    add_index :shop_products, :shop_id
    add_index :shop_products, :admin_product_id
    add_index :questionnaires, :checkin_id
    add_index :questionnaires, :send_message_id
  end
end
