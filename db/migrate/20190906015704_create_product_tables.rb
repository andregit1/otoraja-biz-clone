class CreateProductTables < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_products, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.references :product_category, index: false
      t.references :admin_product, index: false, null: true
      t.string :name, null: true
      t.string :shop_alias_name, null: false
      t.integer :stock_minimum, null: true
      t.integer :sales_unit_price, null: true
      t.integer :remind_interval_day, null: true
      t.boolean :is_use, null: false
      t.timestamps
    end
    create_table :stocks, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop_product, index: false
      t.float :quantity, null: false
      t.timestamps
    end
    create_table :stock_histories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop_product, index: false
      t.date :date, null: false
      t.float :quantity, null: false
      t.timestamps
    end
    create_table :admin_products, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :product_category, index: false
      t.string :name, null: false
      t.integer :default_remind_interval_day, null: true
      t.timestamps
    end
    create_table :product_categories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :product_class, index: false
      t.references :reminder_body_template, index: false, null: true
      t.string :name, null: false
      t.boolean :use_reminder, null: false
      t.boolean :remind_grouping, null: false
      t.timestamps
    end
    create_table :product_classes, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :reminder_body_templates, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :title, null: false
      t.text :template, null: false
      t.timestamps
    end
    create_table :stock_controls, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop_product, index: false
      t.date :date, null: false
      t.references :supplier, index: false, null: true
      t.string :reason, null: false
      t.float :quantity, null: false
      t.string :payment_method, null: true
      t.timestamps
    end
    create_table :purchase_histories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :customer, index: false
      t.string :number_plate_area, limit:10, null: true
      t.string :number_plate_number, limit:10, null: true
      t.string :number_plate_pref, limit:10, null: true
      t.references :shop_product, index: false
      t.datetime :last_purchase_date, null: false
      t.boolean :reminded, null: false
      t.timestamps
    end
    create_table :suppliers, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
