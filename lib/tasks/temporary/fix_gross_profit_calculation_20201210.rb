class FixGrossProfitCalculation20201210
  def self.execute
    puts "executing FixGrossProfitCalculations"
    ActiveRecord::Base.transaction do
      begin
        #convert any stock control inventory records with a value of zero > NULL
        #stock control records with a non NULL non zero value can be used for calculation
        zero_stock_controls = StockControl.where(average_price: 0)
        zero_stock_controls.each do | stock_control |
          if stock_control.shop_invoice&.is_inventory?
            stock_control.average_price = nil
            stock_control.save!
          end
        end
        #find all items with null gross profit MaintenanceLogDetail and checkin not deleted
        mld = MaintenanceLogDetail.where(gross_profit: nil).joins(maintenance_log: :checkin).where("checkins.deleted = false")
        #find nearest stock control record where is_inventory StockControl
        mld.each do | detail |
          next unless detail&.shop_product&.is_stock_control?
          stock_control = detail.shop_product.stock_controls.where.not(average_price: nil).where("created_at <= '#{detail.created_at}'").order(id: :desc).first
          next if stock_control.nil?
          puts detail.inspect, stock_control.inspect
          gross_profit = (detail.unit_price - stock_control.average_price)*detail.quantity
          detail.gross_profit = gross_profit
          detail.save!
        end
      rescue => e
        puts "error FixGrossProfitCalculations #{e.message}", e.backtrace
      end
    end
    puts "finished FixGrossProfitCalculations"
  end
  FixGrossProfitCalculation20201210.execute
end