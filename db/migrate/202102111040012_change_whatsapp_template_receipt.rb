class ChangeWhatsappTemplateReceipt < ActiveRecord::Migration[5.2]
  def change
    change_column :send_messages, :parameters, :text

    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Receipt")
 
      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_receipt_checkout"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_receipt_checkout"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_receipt_checkout"
      )

    end
  end
end
