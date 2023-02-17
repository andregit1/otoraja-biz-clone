class DeleteSubscriptionDataTest
  def self.execute
    Rails.logger.info("Execute delete dummy data Subscription in staging")
    Subscription.delete_all
    shops = Shop.where.not(active_plan: nil)
    begin
      shops.each do |shop| 
        Rails.logger.info("Deleted active plan for Bengkel:#{shop.name}")
        shop.update!(active_plan: nil)
      end
    rescue => e
      Rails.logger.error("Abort Delete dummy data subscription expired")
      Rails.logger.error("error: #{e.message}")
    end      
  end  
end
  
DeleteSubscriptionDataTest.execute