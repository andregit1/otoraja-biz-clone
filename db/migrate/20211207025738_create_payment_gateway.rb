class CreatePaymentGateway < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_gateways do |t|
      t.integer :merchant_id
      t.string :name
      t.string :version
      t.boolean :is_active
      t.timestamps
    end
    
    merchant = [merchant_id: 1, name: 'MidTrans', version: 'ex/v1/', is_active: 1]
    PaymentGateway.create(merchant)
  end
end
