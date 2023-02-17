class CreateTransactionLog < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_logs do |t|
      t.integer :transaction_id
      t.references :subscription, index: true
      t.json :request
      t.json :response
      t.string :response_status
      t.string :status
      t.json :callback_request
      t.json :callback_response
      t.boolean :is_paid, default: false
      t.timestamps
    end
  end
end
