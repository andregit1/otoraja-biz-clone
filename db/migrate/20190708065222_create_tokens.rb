class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :checkin, index: false
      t.string :uuid, null: false
      t.datetime :expired_at, null: false
      t.timestamps
    end
  end
end
