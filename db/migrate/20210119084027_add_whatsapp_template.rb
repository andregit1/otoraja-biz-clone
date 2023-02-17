class AddWhatsappTemplate < ActiveRecord::Migration[5.2]
  def change

    service = WhatsAppService.create(name: "Stock Reminder")

    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_stock_reminder"
    )

  end
end
