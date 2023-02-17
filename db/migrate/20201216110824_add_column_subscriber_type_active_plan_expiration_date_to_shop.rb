class AddColumnSubscriberTypeActivePlanExpirationDateToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :active_plan, :int
    add_column :shops, :expiration_date, :datetime
    add_column :shops, :subscriber_type, :int
    add_column :shops, :virtual_bank_no, :string
  end
end
