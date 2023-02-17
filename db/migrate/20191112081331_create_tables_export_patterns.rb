class CreateTablesExportPatterns < ActiveRecord::Migration[5.2]
  def change
    create_table :export_patterns, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :export_layouts, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.references :export_pattern, index: false
      t.references :export_type, index: false
      t.timestamps
    end

    create_table :export_layout_columns, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :export_layout, index: false
      t.references :export_column, index: false
      t.integer :order, null: false
      t.timestamps
    end

    create_table :export_types, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :export_columns, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.references :export_type, index: false
      t.timestamps
    end

    create_table :export_masking_rules, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :export_layout_column, index: false
      t.boolean :use_masking, null: false
      t.integer :top_no_masking_digits
      t.integer :last_no_masking_digits
      t.timestamps
    end

    add_reference :users, :export_pattern, index: false, :after => :remember_created_at
    
  end
end
