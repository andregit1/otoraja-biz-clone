class CreateQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnaires, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :checkin, index: false
      t.datetime :accessed_at
      t.datetime :url_sent_at
      t.timestamps
    end

    create_table :answers, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :questionnaire, index: false
      t.integer :rate, null: false
      t.string :comment
      t.text :review
      t.datetime :answered_at, null: false
      t.timestamps
    end
  end
end
