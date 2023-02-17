class CreateSendMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :send_messages, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :checkin, index: false
      t.string :from, limit: 20
      t.string :to, null: false, limit: 20
      t.string :body, null: false
      t.integer :send_type, null: false
      t.integer :send_purpose, null: false
      t.datetime :send_datetime, null: false
      t.datetime :sent_at
      t.timestamps
    end

    # 既に存在するチェックインに対して送信済みデータとして登録しておく
    str = 'auto create'
    now = DateTime.now
    Checkin.where.not(checkout_datetime: nil).each do |checkin|
      SendMessage.create(checkin: checkin, to: str, body: str, send_type: :auto_create, send_purpose: :ty, send_datetime: now, sent_at: now)
    end
  end
end
