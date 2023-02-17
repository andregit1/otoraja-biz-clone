class CreateTablesForCampaign < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_types, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer :code_type, null: false
      t.string :campaign_type_code, limit: 15
      t.timestamps
    end

    create_table :campaigns, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :campaign_code, null: false
      t.boolean :is_regular, null: false
      t.datetime :publish_date, null: false
      t.references :shop, index: false      
      t.references :campaign_type, index: false
      t.timestamps
    end

    add_column :admin_products, :campaign_code, :string, :after => :default_remind_interval_day, limit: 15
    add_column :product_categories, :campaign_code, :string, null: false, :after => :remind_grouping, limit: 15

    add_reference :customer_reminder_logs, :campaign, index: false, :after => :checkin_id
    add_reference :product_reminder_logs, :campaign, index: false, :after => :maintenance_log_detail_id
  end
end
