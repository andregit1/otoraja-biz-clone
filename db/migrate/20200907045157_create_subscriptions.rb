class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :shop_group, index: false
      t.integer :plan, :null => false
      t.integer :period
      t.datetime :start_date
      t.datetime :end_date
      t.integer :fee
      t.integer :status
      t.text :reason_for_cancellation, length: 255
      t.timestamps
    end
  end
end
