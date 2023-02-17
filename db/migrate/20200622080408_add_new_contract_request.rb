class AddNewContractRequest < ActiveRecord::Migration[5.2]
  def change
    create_table :new_contract_requests, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.string :email
      t.string :tel
      t.string :shop_name
      t.string :shop_address
      t.integer :business_form
      t.integer :number_of_employees
      t.date    :desired_start_date
      t.integer :status
      t.timestamps
    end
  end
end
