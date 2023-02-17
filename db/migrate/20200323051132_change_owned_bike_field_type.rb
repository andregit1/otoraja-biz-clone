class ChangeOwnedBikeFieldType < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      OwnedBike.where(expiration_month: '').or(OwnedBike.where(expiration_year: '')).each do |owned_bike|
        owned_bike.update_attribute(:expiration_month, nil) if owned_bike.expiration_month == ''
        owned_bike.update_attribute(:expiration_year, nil) if owned_bike.expiration_year == ''
      end
    end

    change_column :owned_bikes, :expiration_month, :integer
    change_column :owned_bikes, :expiration_year, :integer
  end
  def down
    change_column :owned_bikes, :expiration_month, :string, :limit => 45
    change_column :owned_bikes, :expiration_year, :string, :limit => 45
  end
end
