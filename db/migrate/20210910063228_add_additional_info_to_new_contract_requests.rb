class AddAdditionalInfoToNewContractRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :new_contract_requests, :is_otoraja_biz, :boolean
    add_column :new_contract_requests, :is_otoraja_bp, :boolean
    add_column :new_contract_requests, :referral, :string
  end
end
