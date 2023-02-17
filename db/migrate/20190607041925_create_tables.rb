class CreateTables < ActiveRecord::Migration[5.2]
  def change

    create_table :available_shops, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.references :user, index: false
      t.timestamps
    end

    create_table :bike_models, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :maker, index: false
      t.string :name, limit: 45, null: false
      t.string :displacement, limit: 45, null: false
      t.timestamps
    end

    create_table :bikes, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :maker, limit: 45, null: false
      t.string :model, limit: 45, null: false
      t.string :displacement, limit: 45, null: false
      t.timestamps
    end

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

    create_table :checkins, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :customer, index: false
      t.references :shop, index: false
      t.datetime :datetime, null: false
      t.timestamps
    end

    create_table :customers, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer :tel
      t.string :email, limit: 100
      t.string :name, limit: 45
      t.integer :gender
      t.string :cognito_id, limit: 45
      t.string :cognito_pw, limit: 8
      t.references :region, index: false
      t.references :province, index: false
      t.references :regencie, index: false
      t.boolean :send_dm
      t.timestamps
    end

    create_table :maintenance_log_details, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :maintenance_log, index: false
      t.references :maintenance_menu, index: false
      t.string :name, limit: 100
      t.integer :quantity
      t.integer :unit_price
      t.text :note
      t.timestamps
    end

    create_table :maintenance_logs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :checkin, index: false
      t.integer :mileage
      t.string :number_plate_area, limit: 10
      t.string :number_plate_number, limit: 10
      t.string :number_plate_pref, limit: 10
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :maker, limit: 45
      t.string :model, limit: 45
      t.string :displacement, limit: 45
      t.timestamps
    end

    create_table :maintenance_menus, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, limit: 100, null: false
      t.timestamps
    end

    create_table :makers, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, limit: 45, null: false
      t.timestamps
    end

    create_table :owned_bikes, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :bike, index: false
      t.references :customer, index: false
      t.string :number_plate_area, limit: 45, null: false
      t.string :number_plate_number, limit: 45, null: false
      t.string :number_plate_pref, limit: 45, null: false
      t.string :expiration_month, limit: 45, null: false
      t.string :expiration_year, limit: 45, null: false
      t.timestamps
    end

    create_table :provinces, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.references :region, index: false
      t.timestamps
    end

    create_table :regencies, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer :type, null: false
      t.string :name, null: false
      t.string :capital_name, null: false
      t.references :province, index: false
      t.timestamps
    end

    create_table :regions, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
