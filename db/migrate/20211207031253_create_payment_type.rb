class CreatePaymentType < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_types do |t|
      t.integer :payment_type_id
      t.references :payment_gateway, index: true
      t.string :name
      t.string :title
      t.text :payment_instruction
      t.string :icon_path 
      t.boolean :is_use_all
      t.boolean :is_active
      t.json :shop_list
      t.integer :expiration_interval
      t.timestamps
    end

    payment_types = [
      [payment_type_id: 1, payment_gateway_id: 1, name: 'gopay', title: 'GoPay', payment_instruction: 'gopay_instructions_html', icon_path: 'assets/images/logo-gopay.png', is_use_all: 1, is_active: 1, expiration_interval: 5],
      [payment_type_id: 2, payment_gateway_id: 1, name: 'qris_gopay', title: 'Qris', payment_instruction: 'qris_instructions_html', icon_path: 'assets/images/logo-qris.png', is_use_all: 1, is_active: 1, expiration_interval: 5],
      [payment_type_id: 3, payment_gateway_id: 1, name: 'qris_shopee', title: 'Qris', payment_instruction: 'qris_instructions_html', icon_path: 'assets/images/logo-qris.png', is_use_all: 1,is_active: 1, expiration_interval: 5],
      [payment_type_id: 4, payment_gateway_id: 1, name: 'bca_va', title: 'BCA VA', payment_instruction: 'bca_instructions_html', icon_path: 'assets/images/logo-bca-va.png', is_use_all: 1, is_active: 1, expiration_interval: 1440],
      [payment_type_id: 5, payment_gateway_id: 1, name: 'bri_va', title: 'BRI VA', payment_instruction: 'bri_instructions_html', icon_path: 'assets/images/logo-bri-va.png', is_use_all: 1, is_active: 1, expiration_interval: 1440],
      [payment_type_id: 6, payment_gateway_id: 1, name: 'bni_va', title: 'BNI VA', payment_instruction: 'bni_instructions_html', icon_path: 'assets/images/logo-bni-va.png', is_use_all: 1, is_active: 1, expiration_interval: 1440],
      [payment_type_id: 7, payment_gateway_id: 1, name: 'mandiri_bill', title: 'Mandiri', payment_instruction: 'mandiri_instructions_html', icon_path:'assets/images/logo-mandiri.png', is_use_all: 1, is_active: 1, expiration_interval: 1440]
    ]
    PaymentType.create(payment_types)
  end
end
