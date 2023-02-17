class AddRegencyAndDistricToNewContractRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :new_contract_requests, :regency, index: true
    add_reference :new_contract_requests, :distric, index: true
  end
end
