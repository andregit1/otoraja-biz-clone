class InsertRecordToProductClass < ActiveRecord::Migration[5.2]
  def change
    if ProductClass.all.count > 0
      ProductClass.create(name: 'UNCATEGORIZED', can_includable: true)
    end

    if ProductCategory.all.count > 0
      product_class = ProductClass.find_by(name: 'UNCATEGORIZED')
      ProductCategory.create(product_class: product_class, name: 'TANPA KATEGORI',use_reminder: 0, remind_grouping: 0, campaign_code: 'TANPA KATEGORI') unless product_class.nil?
    end
  end
end
