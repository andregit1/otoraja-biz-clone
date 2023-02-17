class DropCampaignTables < ActiveRecord::Migration[5.2]
  def up
    drop_table :campaign_targets
    drop_table :campaigns
    drop_table :campaign_body_templates
  end

  def down 
    create_table :campaign_body_templates, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.text :template, null: false
      t.string :description, limit: 45
      t.timestamps
    end

    create_table :campaign_targets, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :campaign, index: false
      t.references :customer, index: false
      t.timestamps
    end

    create_table :campaigns, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.string :senderid, limit: 11, null: false
      t.text :body, null: false
      t.datetime :send_datetime, null: false
      t.string :campaign_code, limit: 10, null: false
      t.string :pinpoint_id, limit: 45
      t.timestamps
    end
  end
end
