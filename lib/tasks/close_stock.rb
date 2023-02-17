class CloseStock
  def self.execute
    begin
      ## This task will be run at 23:00 WIB UTC+7
      shops = Shop.where.not(subscriber_type: 0)
      stocks = Stock.joins(:shop_product).where(shop_products: {shop: shops, is_stock_control: true})
      
      return puts "Stock history already registered" if StockHistory.find_by_date(Date.today)

      stock_histories = stocks.as_json.map{|x| x.except('id', 'created_at', 'updated_at').merge!(date: Date.today)}   

      StockHistory.import stock_histories
      puts "Stock histories registration completed."
    rescue => exception
      puts "#{exception} file: close_stock.rb"
      puts exception.backtrace.join("\n")
    end
  end
end

CloseStock.execute