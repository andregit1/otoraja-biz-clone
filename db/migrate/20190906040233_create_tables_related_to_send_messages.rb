class CreateTablesRelatedToSendMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_choice_groups, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name

      t.timestamps
    end

    create_table :customer_reminder_logs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :send_message, index: false
      t.references :customer, index: false

      t.timestamps
    end

    create_table :product_reminder_logs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :send_message, index: false
      t.references :maintenance_log_detail, index: false

      t.timestamps
    end
  end
end
