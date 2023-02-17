class DataPatchShopProductStockMinimum20210428
  def self.execute
    puts 'Execute data_patch_shop_product_stock_minimum_20210428.rb'
    update_count = 0
    ActiveRecord::Base.transaction do
      shop_products = ShopProduct.joins(:stock, :stock_controls, :shop_invoices).where(is_stock_control: true, stock_minimum: nil)
      shop_products.map do |shop_product|
        shop_product.stock_minimum = 1
        shop_product.save!
        update_count += 1
      end
    end
    puts "Result: Update stock_minimum null to 1 for #{update_count} record."
  rescue => e
    puts "Error: #{e}, File: data_patch_shop_product_stock_minimum_20210428.rb"
  end
end

DataPatchShopProductStockMinimum20210428.execute
