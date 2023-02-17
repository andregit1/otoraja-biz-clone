class CreateShopBusinessHours < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_business_hours, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.boolean :is_holiday
      t.string :day_of_week, limit: 3, null: false
      t.integer :open_time_hour, null: true
      t.integer :open_time_minute, null: true
      t.integer :close_time_hour, null: true
      t.integer :close_time_minute, null: true
      t.timestamps
    end
  end
end
