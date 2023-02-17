class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :shop_available_payment_methods, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.references :payment_method, index: false
      t.timestamps
    end
    create_table :maintenance_log_payment_methods, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :maintenance_log, index: false
      t.references :payment_method, index: false
      t.integer :amount, null: false
      t.bigint :created_staff_id, null: false
      t.string :created_staff_name, :limit => 45, null: false
      t.bigint :updated_staff_id, null: false
      t.string :updated_staff_name, :limit => 45, null: false
      t.timestamps
    end

    # 初期データ投入
    ['Cash', 'Credit/Debit', 'Invoice', 'EDC', 'Other'].each do |method|
      PaymentMethod.create(name: method)
    end
    payment_method_cash = PaymentMethod.find_by(name: 'Cash')
    payment_method_card = PaymentMethod.find_by(name: 'Credit/Debit')
    payment_method_other = PaymentMethod.find_by(name: 'Other')
    Shop.all.each do |shop|
      ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_cash)
      ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_card)
      ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_other)
    end
  end
end
