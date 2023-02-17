# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 202102111040012) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_product_designated_motorcycles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "bike_model_id"
    t.bigint "admin_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_category_id"
    t.string "product_no"
    t.string "name", null: false
    t.string "item_detail"
    t.integer "default_remind_interval_day"
    t.string "campaign_code", limit: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brand_id"
    t.bigint "variant_id"
    t.bigint "tech_spec_id"
    t.index ["brand_id"], name: "index_admin_products_on_brand_id"
    t.index ["tech_spec_id"], name: "index_admin_products_on_tech_spec_id"
    t.index ["variant_id"], name: "index_admin_products_on_variant_id"
  end

  create_table "answer_choice_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answer_choices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "export_id", null: false
    t.string "choice", null: false
    t.boolean "positive", null: false
    t.bigint "answer_choice_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.integer "rate", null: false
    t.string "comment", limit: 500
    t.text "review"
    t.string "reasons"
    t.datetime "answered_at", null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "available_shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bike_models", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "maker_id"
    t.string "name", limit: 45, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bikes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "maker", limit: 45
    t.string "model", limit: 45
    t.string "color"
    t.integer "odometer"
    t.datetime "odometer_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name"
  end

  create_table "campaign_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "code_type", null: false
    t.string "campaign_type_code", limit: 15
    t.bigint "reminder_body_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "campaign_code", null: false
    t.boolean "is_regular", null: false
    t.datetime "publish_date", null: false
    t.bigint "shop_id"
    t.bigint "campaign_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "shop_id"
    t.datetime "datetime", null: false
    t.datetime "checkout_datetime"
    t.boolean "deleted", null: false
    t.string "created_staff_name", limit: 45, null: false
    t.bigint "created_staff_id", null: false
    t.string "updated_staff_name", limit: 45, null: false
    t.bigint "updated_staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkout_datetime"], name: "index_checkins_on_checkout_datetime"
    t.index ["created_at"], name: "index_checkins_on_created_at"
    t.index ["created_staff_id"], name: "index_checkins_on_created_staff_id"
    t.index ["deleted"], name: "index_checkins_on_deleted"
  end

  create_table "customer_reminder_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "send_message_id"
    t.bigint "customer_id"
    t.bigint "checkin_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "tel", limit: 20
    t.string "tmp_tel", limit: 20
    t.string "email", limit: 100
    t.string "tmp_email", limit: 100
    t.string "name", limit: 45
    t.integer "gender"
    t.string "cognito_id", limit: 45
    t.string "cognito_pw", limit: 8
    t.bigint "region_id"
    t.bigint "province_id"
    t.bigint "regencie_id"
    t.boolean "send_dm"
    t.integer "receipt_type"
    t.integer "send_type"
    t.string "wa_tel", limit: 20
    t.datetime "terms_agreed_at"
    t.datetime "mypage_terms_agreed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_request_count", default: 0
    t.datetime "token_locked_at"
    t.index ["tel"], name: "index_customers_on_tel"
  end

  create_table "customize_shop_product_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "customize_shop_product_list_id"
    t.bigint "shop_product_id"
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customize_shop_product_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "name", null: false
    t.integer "order", null: false
    t.boolean "can_add_all", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_columns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "export_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_layout_columns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "export_layout_id"
    t.bigint "export_column_id"
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_layouts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "export_pattern_id"
    t.bigint "export_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_masking_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "export_layout_column_id"
    t.boolean "use_masking", null: false
    t.integer "top_no_masking_digits"
    t.integer "last_no_masking_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_patterns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "export_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixed_average_prices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_product_id"
    t.bigint "average_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_product_id"], name: "index_fixed_average_prices_on_shop_product_id"
  end

  create_table "maintenance_log_detail_related_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "maintenance_log_detail_id"
    t.bigint "shop_product_id"
    t.string "product_no"
    t.string "category_name"
    t.string "item_name"
    t.string "item_detail"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maintenance_log_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "maintenance_log_id"
    t.bigint "maintenance_menu_id"
    t.bigint "shop_product_id"
    t.string "product_no"
    t.string "name", limit: 510
    t.string "description"
    t.float "quantity"
    t.integer "unit_price"
    t.integer "sub_total_price"
    t.integer "gross_profit"
    t.integer "discount_type"
    t.integer "discount_rate"
    t.bigint "discount_amount", default: 0
    t.text "remarks"
    t.string "created_staff_name", limit: 45, null: false
    t.bigint "created_staff_id", null: false
    t.string "updated_staff_name", limit: 45, null: false
    t.bigint "updated_staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_maintenance_log_details_on_created_at"
    t.index ["maintenance_log_id"], name: "index_maintenance_log_details_on_maintenance_log_id"
    t.index ["maintenance_menu_id"], name: "index_maintenance_log_details_on_maintenance_menu_id"
    t.index ["unit_price"], name: "index_maintenance_log_details_on_unit_price"
  end

  create_table "maintenance_log_payment_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "maintenance_log_id"
    t.bigint "payment_method_id"
    t.integer "amount", null: false
    t.bigint "created_staff_id", null: false
    t.string "created_staff_name", limit: 45, null: false
    t.bigint "updated_staff_id", null: false
    t.string "updated_staff_name", limit: 45, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_staff_id"], name: "index_maintenance_log_payment_methods_on_created_staff_id"
    t.index ["maintenance_log_id"], name: "index_maintenance_log_payment_methods_on_maintenance_log_id"
    t.index ["payment_method_id"], name: "index_maintenance_log_payment_methods_on_payment_method_id"
  end

  create_table "maintenance_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "checkin_id"
    t.string "name", limit: 45
    t.integer "mileage"
    t.string "number_plate_area", limit: 10
    t.string "number_plate_number", limit: 10
    t.string "number_plate_pref", limit: 10
    t.integer "expiration_month"
    t.integer "expiration_year"
    t.string "maker", limit: 45
    t.string "model", limit: 45
    t.string "displacement", limit: 45
    t.string "reason"
    t.string "color"
    t.integer "previous_odometer"
    t.datetime "previous_odometer_updated_at"
    t.integer "odometer"
    t.datetime "odometer_updated_at"
    t.string "created_staff_name", limit: 45, null: false
    t.bigint "created_staff_id", null: false
    t.string "updated_staff_name", limit: 45, null: false
    t.bigint "updated_staff_id", null: false
    t.bigint "maintained_staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "remarks"
    t.integer "total_price"
    t.integer "amount_paid"
    t.integer "adjustment"
    t.integer "down_payment_amount"
    t.index ["checkin_id"], name: "index_maintenance_logs_on_checkin_id"
    t.index ["created_at"], name: "index_maintenance_logs_on_created_at"
    t.index ["maintained_staff_id"], name: "index_maintenance_logs_on_maintained_staff_id"
    t.index ["updated_staff_id"], name: "index_maintenance_logs_on_updated_staff_id"
  end

  create_table "maintenance_mechanics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "maintenance_log_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shop_staff_id"
    t.index ["created_at"], name: "index_maintenance_mechanics_on_created_at"
    t.index ["shop_staff_id"], name: "index_maintenance_mechanics_on_shop_staff_id"
  end

  create_table "maintenance_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "makers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 45, null: false
    t.integer "order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_contract_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "tel"
    t.string "shop_name"
    t.string "shop_address"
    t.integer "business_form"
    t.integer "number_of_employees"
    t.date "desired_start_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_otoraja_biz"
    t.boolean "is_otoraja_bp"
    t.string "referral"
  end

  create_table "notification_shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "notification_id"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_tag_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "notification_id"
    t.bigint "notification_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.string "text_color"
    t.string "body_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "subject", null: false
    t.text "body"
    t.integer "status", default: 0
    t.datetime "published_from"
    t.datetime "published_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owned_bikes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "bike_id"
    t.bigint "customer_id"
    t.string "number_plate_area", limit: 45, null: false
    t.string "number_plate_number", limit: 45, null: false
    t.string "number_plate_pref", limit: 45, null: false
    t.integer "expiration_month"
    t.integer "expiration_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_owned_bikes_on_customer_id"
    t.index ["number_plate_area", "number_plate_number", "number_plate_pref"], name: "index_owned_bikes_on_number_plate"
  end

  create_table "packaging_product_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "packaging_product_id"
    t.bigint "inclusion_product_id"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "polling_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "poll"
    t.datetime "executed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_class_id"
    t.bigint "reminder_body_template_id"
    t.string "name", null: false
    t.boolean "use_reminder", null: false
    t.boolean "remind_grouping", null: false
    t.string "campaign_code", limit: 15, null: false
    t.string "brand_validation", default: "optional", null: false
    t.string "variant_validation", default: "optional", null: false
    t.string "tech_spec_validation", default: "optional", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_product_categories_on_id"
  end

  create_table "product_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "can_includable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_reminder_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "send_message_id"
    t.bigint "maintenance_log_detail_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provinces", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "number_plate_area", limit: 10
    t.string "number_plate_number", limit: 10
    t.string "number_plate_pref", limit: 10
    t.bigint "shop_product_id"
    t.datetime "last_purchase_date", null: false
    t.boolean "reminded", null: false
    t.bigint "maintenance_log_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questionnaires", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "checkin_id"
    t.datetime "accessed_at"
    t.bigint "answer_choice_group_id"
    t.bigint "send_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkin_id"], name: "index_questionnaires_on_checkin_id"
    t.index ["send_message_id"], name: "index_questionnaires_on_send_message_id"
  end

  create_table "regencies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "type", null: false
    t.string "name", null: false
    t.string "capital_name", null: false
    t.bigint "province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminder_body_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "template", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "send_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "from", limit: 50
    t.string "to", limit: 50, null: false
    t.text "cc"
    t.string "subject"
    t.text "body", null: false
    t.integer "send_type", null: false
    t.integer "send_purpose", null: false
    t.string "message_id"
    t.datetime "send_datetime", null: false
    t.datetime "sent_at"
    t.string "query_id"
    t.string "send_status"
    t.float "send_cost"
    t.integer "resend_attempts"
    t.text "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shop_available_payment_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "payment_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_business_hours", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.boolean "is_holiday"
    t.string "day_of_week", limit: 3, null: false
    t.integer "open_time_hour"
    t.integer "open_time_minute"
    t.integer "close_time_hour"
    t.integer "close_time_minute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_configs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.integer "questionnaire_expiration_days", default: 3, null: false
    t.time "message_send_time", default: "2000-01-01 14:00:00", null: false
    t.string "front_priority_display", null: false
    t.boolean "use_customer_remind", null: false
    t.integer "customer_remind_interval_days"
    t.boolean "use_receipt", null: false
    t.string "receipt_layout"
    t.integer "receipt_open_expiration_days"
    t.string "stock_notification_destination", limit: 20
    t.boolean "use_stock_notification", null: false
    t.boolean "use_record_stock", null: false
    t.time "close_stock_time", null: false
    t.string "rounding_direction"
    t.integer "round_to"
    t.integer "num_of_custom_list", null: false
    t.integer "num_of_products_in_custom_list", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "value"
    t.string "no_ref"
    t.text "description"
    t.bigint "supplier_id"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expense_date"
    t.index ["shop_id"], name: "index_shop_expenses_on_shop_id"
    t.index ["supplier_id"], name: "index_shop_expenses_on_supplier_id"
  end

  create_table "shop_facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "facility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "group_no", limit: 20, null: false
    t.string "name", null: false
    t.string "owner_name"
    t.integer "owner_gender"
    t.string "owner_tel"
    t.string "owner_tel2"
    t.string "owner_email", limit: 100
    t.integer "founding_year"
    t.boolean "is_chain_shop"
    t.integer "subscriber_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_plan"
    t.datetime "expiration_date"
    t.string "virtual_bank_no"
    t.string "owner_wa_tel"
  end

  create_table "shop_invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "invoice_no"
    t.bigint "shop_id"
    t.bigint "supplier_id"
    t.datetime "arrival_date"
    t.string "payment_method"
    t.integer "status"
    t.boolean "is_inventory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_invoices_on_shop_id"
  end

  create_table "shop_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "product_category_id"
    t.bigint "admin_product_id"
    t.string "product_no"
    t.string "shop_alias_name", null: false
    t.string "item_detail"
    t.integer "stock_minimum"
    t.integer "sales_unit_price"
    t.integer "remind_interval_day"
    t.boolean "is_stock_control", null: false
    t.boolean "is_use", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brand_id"
    t.bigint "variant_id"
    t.bigint "tech_spec_id"
    t.datetime "deleted_at"
    t.index ["admin_product_id"], name: "index_shop_products_on_admin_product_id"
    t.index ["brand_id"], name: "index_shop_products_on_brand_id"
    t.index ["deleted_at"], name: "index_shop_products_on_deleted_at"
    t.index ["product_category_id"], name: "index_shop_products_on_product_category_id"
    t.index ["shop_id"], name: "index_shop_products_on_shop_id"
    t.index ["tech_spec_id"], name: "index_shop_products_on_tech_spec_id"
    t.index ["variant_id"], name: "index_shop_products_on_variant_id"
  end

  create_table "shop_search_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "name"
    t.integer "order"
    t.boolean "is_using"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "name", limit: 45, null: false
    t.boolean "is_front_staff", null: false
    t.boolean "is_mechanic", null: false
    t.integer "mechanic_grade"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_mechanic"], name: "index_shop_staffs_on_is_mechanic"
    t.index ["shop_id"], name: "index_shop_staffs_on_shop_id"
  end

  create_table "shop_visiting_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "visiting_reason_id"
    t.integer "display"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_whats_app_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "whats_app_service_id"
    t.bigint "whats_app_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "bengkel_id"
    t.bigint "shop_group_id"
    t.string "name"
    t.string "tel"
    t.string "tel2"
    t.string "tel3"
    t.string "address"
    t.float "longitude"
    t.float "latitude"
    t.bigint "region_id"
    t.bigint "province_id"
    t.bigint "regency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_plan"
    t.datetime "expiration_date"
    t.integer "subscriber_type"
    t.string "virtual_bank_no"
    t.boolean "initial_setup", default: true
    t.boolean "is_reactivated", default: false
    t.index ["bengkel_id"], name: "index_shops_on_bengkel_id", unique: true
  end

  create_table "shortened_urls", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type", limit: 20
    t.text "url", null: false
    t.string "unique_key", limit: 10, null: false
    t.string "category"
    t.integer "use_count", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category"], name: "index_shortened_urls_on_category"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type"
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true
    t.index ["url"], name: "index_shortened_urls_on_url", length: 768
  end

  create_table "stock_controls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_product_id"
    t.bigint "shop_invoice_id"
    t.date "date", null: false
    t.bigint "supplier_id"
    t.string "reason", null: false
    t.float "quantity", null: false
    t.bigint "purchase_unit_price"
    t.bigint "purchase_price"
    t.bigint "average_price"
    t.string "payment_method"
    t.float "difference"
    t.float "stock_at_close"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_invoice_id"], name: "index_stock_controls_on_shop_invoice_id"
    t.index ["shop_product_id"], name: "index_stock_controls_on_shop_product_id"
  end

  create_table "stock_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_product_id"
    t.date "date", null: false
    t.float "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_product_id"
    t.float "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_product_id"], name: "index_stocks_on_shop_product_id"
  end

  create_table "subscription_fees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "subscription_plan_id"
    t.bigint "subscription_period_id"
    t.integer "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_periods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "label"
    t.integer "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_day"
  end

  create_table "subscription_plans", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_group_id"
    t.integer "plan", null: false
    t.integer "period"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "fee"
    t.integer "status"
    t.text "reason_for_cancellation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shop_id"
    t.string "invoice_number", limit: 25
    t.string "form_number", limit: 25
    t.date "payment_date"
    t.datetime "payment_expired"
    t.bigint "va_code_area_id"
    t.string "sales_name"
    t.index ["shop_id"], name: "index_subscriptions_on_shop_id"
  end

  create_table "suppliers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "name", null: false
    t.string "address"
    t.string "tel", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tech_specs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_category_id"
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tech_specs_on_name"
  end

  create_table "terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "terms", null: false
    t.datetime "effective_date", null: false
    t.integer "terms_purpose", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "checkin_id"
    t.bigint "customer_id"
    t.bigint "subscription_id"
    t.string "uuid", null: false
    t.integer "token_purpose", null: false
    t.datetime "expired_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_tokens_on_uuid"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 45, null: false
    t.string "user_id"
    t.string "email", default: "", null: false
    t.string "role", limit: 20
    t.string "status", limit: 10, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "export_pattern_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "provider", default: "user_id", null: false
    t.string "uid", default: "", null: false
    t.text "tokens"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "password_updated_at"
    t.boolean "is_otoraja_biz"
    t.boolean "is_otoraja_bp"
    t.string "referral"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  create_table "va_code_areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "province_id"
    t.integer "va_code"
    t.string "area_name"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "variants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_category_id"
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_variants_on_name"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "android_require_version"
    t.string "android_latest_version"
    t.string "ios_require_version"
    t.string "ios_latest_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visiting_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whats_app_invites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "whats_app_service_id"
    t.bigint "customer_id"
    t.string "hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whats_app_optins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "whats_app_service_id"
    t.bigint "whats_app_invite_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whats_app_services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "whats_app_template_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whats_app_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "whats_app_service_id"
    t.integer "environment"
    t.string "template_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
