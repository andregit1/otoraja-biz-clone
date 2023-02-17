class DataPatchBulkUpdateStockControlMarganda_20221702
  def self.execute
    puts "Executing Data Patch on Bengkel Margonda set shop products is_stock_control to true"
    
    ShopProduct.where(shop_id: 1846).update(is_stock_control: true)
    
    puts "Finished Data Patch on Bengkel Margonda set shop products is_stock_control to true"
  end
end

DataPatchBulkUpdateStockControlMarganda_20221702.execute
