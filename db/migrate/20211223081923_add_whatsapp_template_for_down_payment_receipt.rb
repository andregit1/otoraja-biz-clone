class AddWhatsappTemplateForDownPaymentReceipt < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Receipt")
  
      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_down_payment_receipt_v1"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_down_payment_receipt_v1"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_down_payment_receipt_v1"
      )
    end
  end
end
