class CreateCashFlowHistoriesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_flow_histories do |t|
      t.integer :cash_amount
      t.datetime :cash_paid_date
      t.string :cash_in_out
      t.string :cash_type
      t.references :cashable, polymorphic: true, index: true
      t.boolean  :sent_wa_receipt
      t.timestamps
    end
  end
end
