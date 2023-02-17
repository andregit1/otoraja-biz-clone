include Rails.application.routes.url_helpers

class StockReminder
  def self.execute
    begin
      puts "Start sent stock reminder"

      shop_need_to_send_stock_notification.each do |shop| 
        send_to_wa(shop)
      end

      puts "Finish sent stock reminder"
    rescue => exception
      puts "#{exception} file: stock_reminder.rb"
      puts exception.backtrace.join("\n")
    end
  end

  private

  def self.shops_with_crictical_stocks
    Stock.joins(:shop_product)
          .where(shop_products: {is_stock_control: true})
          .where('shop_products.stock_minimum >= stocks.quantity')
          .pluck(:shop_id).uniq
  end

  def self.shop_need_to_send_stock_notification
    Shop.joins(:shop_config).where.not(subscriber_type: 0)
        .where.not(shop_configs: {stock_notification_destination: nil})
        .where(id: shops_with_crictical_stocks)
        .where(shop_configs: {use_stock_notification: 1, close_stock_time: 59.minutes.ago..Time.now})
  end

  def self.send_to_wa(shop)
    domain = ENV['DOMAIN_NAME'] || 'localhost'
    protocol = Rails.env.development?? "http://" : "https://"
    stock_reminder_url = "#{protocol}#{domain}/admin/low_stock_report"

    template = WhatsAppTemplate.get_template_by_name(WhatsAppTemplate.names[:daily_stock_notification])

    object_wa = {
      to: [shop.shop_config.trim_stock_notification_destination], 
      from: "system", 
      template: template, 
      send_purpose: :daily_stock_notification, 
      params: [stock_reminder_url]
    }

    Whatsapp::WhatsappUtility.send_wa_notification(object_wa)
  end
end

StockReminder.execute