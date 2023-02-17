class DataPatchShopProductStockControl20210324
  def self.execute
    puts 'Execute data_patch_shop_product_stock_control.rb'
    update_count = 0
    ActiveRecord::Base.transaction do
      shop_products = ShopProduct.joins(:stock, :stock_controls, :shop_invoices).where(is_stock_control: false);
      shop_products.map do |shop_product|
        shop_product.is_stock_control = true;
        shop_product.save!
        update_count += 1
      end
    end
    puts "Result: Update is_stock_control to true for #{update_count} record."
  rescue => e
    puts "Error: #{e}, File: data_patch_shop_product_stock_control.rb"
  end
end

DataPatchShopProductStockControl20210324.execute
