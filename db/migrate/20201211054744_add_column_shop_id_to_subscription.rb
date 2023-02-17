class AddColumnShopIdToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :shop, foreign_key: false
  end
end
