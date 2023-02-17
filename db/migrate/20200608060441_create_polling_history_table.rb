class CreatePollingHistoryTable < ActiveRecord::Migration[5.2]
  def change
    create_table :polling_histories do |t|
      t.integer :poll, index: false
      t.datetime :executed_at, index: false
      t.timestamps
    end
    PollingHistory.create(poll: :whats_app_outbound_messages, executed_at: DateTime.now.utc)
  end
end
