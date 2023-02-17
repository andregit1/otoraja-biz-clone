require 'csv'

CSV.generate(force_quotes: true) do |csv|
  csv << ShopProductUpload.columns
  @admin_products.each do |admin_product|
    column_values = [
      admin_product&.product_no,                            # product_no​
      admin_product.product_category.product_class.name,    # product_class_name​
      admin_product.product_category.id,                    # product_category_id​
      admin_product.product_category.name,                  # product_category_name​
      admin_product.id,                                     # admin_product_id​
      admin_product.name,                                   # shop_alias_name​
      admin_product&.item_detail,                           # item_detail​
      '',                                                   # stock_minimum​
      '',                                                   # sales_unit_price​
      admin_product.default_remind_interval_day,            # remind_interval_day​
      '',                                                   # stock​
      '',                                                   # in_store​
    ]
    csv << column_values
  end
end
