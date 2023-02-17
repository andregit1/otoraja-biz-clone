class AddOrderIdSubscription < ActiveRecord::Migration[5.2]
  def change
    execute "
      ALTER TABLE subscriptions
      ADD COLUMN order_ids VARCHAR(8)
      GENERATED ALWAYS AS (
        LEFT(
            CONCAT(
                    COALESCE(subscriptions.shop_id, '1'), 
                    MD5(
                        CONCAT(
                                COALESCE(subscriptions.shop_id, '1'),
                                COALESCE(subscriptions.shop_group_id, '1'), 
                                COALESCE(subscriptions.plan, '1'), 
                                COALESCE(subscriptions.period, '1'), 
                                COALESCE(subscriptions.created_at, '1999-99-99 99:99:99')
                              )
                        )
                  ),
         8)
      ) STORED AFTER ID;
    "
    end
end
