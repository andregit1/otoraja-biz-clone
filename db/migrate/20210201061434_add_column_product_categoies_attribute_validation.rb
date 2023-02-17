class AddColumnProductCategoiesAttributeValidation < ActiveRecord::Migration[5.2]
  def change
    add_column :product_categories, :tech_spec_validation, :string, :null => false, :default =>  'optional', :after => "campaign_code"
    add_column :product_categories, :variant_validation, :string, :null => false, :default =>  'optional', :after => "campaign_code"
    add_column :product_categories, :brand_validation, :string, :null => false, :default =>  'optional', :after => "campaign_code"
  end
end
