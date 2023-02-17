class AddSalesAndCodeAreaField < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :va_code_area, index: false
    add_column :subscriptions, :sales_name, :string
  end
end