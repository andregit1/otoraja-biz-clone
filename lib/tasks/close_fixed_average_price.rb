class CloseFixedAveragePrice
    def self.execute
        puts "executing close_fixed_average_price.rb"
        shops = Shop.own_shop(AvailableShop.group(:shop_id).pluck(:shop_id))
        shops.each do |shop|
            begin
                #get shop products
                products = ShopProduct.where(shop_id: shop.id);
                products.each do |product|
                    stockControls = StockControl.where(shop_product_id: product.id)
                    unless stockControls.count==0
                        #get last record from fixed prices. If there is no record, 
                        #create the first from the latest record in stock_control
                        lastRecord = FixedAveragePrice.where(shop_product_id: product.id).first()
                        if lastRecord.nil?
                            FixedAveragePrice.create(shop_product_id: product.id, average_price: stockControls.last().average_price)
                        else
                            lastRecord.update(average_price: stockControls.last().average_price, updated_at: DateTime.now.utc)
                        end
                    end
                end
            rescue => exception
                puts "#{exception} file: close_fixed_average_price.rb"
                puts exception.backtrace.join("\n")
            end
        end
    end
end

CloseFixedAveragePrice.execute