class AddDailyStockNotificationWhatsappTemplate < ActiveRecord::Migration[5.2]
  def change
    WhatsAppTemplate.create(template_name: "daily_stock_notification", whats_app_service_id: 3, environment: WhatsAppTemplate.environmentTypes[:production])
    WhatsAppTemplate.create(template_name: "daily_stock_notification", whats_app_service_id: 3, environment: WhatsAppTemplate.environmentTypes[:staging])
    WhatsAppTemplate.create(template_name: "daily_stock_notification", whats_app_service_id: 3, environment: WhatsAppTemplate.environmentTypes[:development])
  end
end
