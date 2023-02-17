class CreateAnswerChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_choices, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :choice, null: false
      t.boolean :positive, null: false
      t.timestamps
    end
  end
end
