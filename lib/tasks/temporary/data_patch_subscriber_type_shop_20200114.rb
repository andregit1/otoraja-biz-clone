class DataPatchSubscriberTypeShop20200114
  def self.execute
    puts "Executing Data Patch on Shops"
    ActiveRecord::Base.transaction do 
      begin  
        Shop.all.each do |shop|
          if shop.shop_group.present?
            shop.subscriber_type = shop.shop_group.subscriber_type if shop.subscriber_type.nil?
            shop.save!
          else
            shop.non_subscriber!
          end
        end
      rescue => e
        puts e.message
        Rails.logger.error(e.message)
      end
    end
    puts "Finished Execute Data Patch Oo Shops"
  end
end

DataPatchSubscriberTypeShop20200114.execute
