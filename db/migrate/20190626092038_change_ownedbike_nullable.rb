class ChangeOwnedbikeNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :owned_bikes, :expiration_month, true
    change_column_null :owned_bikes, :expiration_year, true
  end
end
