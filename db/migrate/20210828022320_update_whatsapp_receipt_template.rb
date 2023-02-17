class UpdateWhatsappReceiptTemplate < ActiveRecord::Migration[5.2]
  def change
    service = WhatsAppService.find_by(name: "Receipt")

    # customer receipt
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_receipt_new_v2"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_receipt_new_v2"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_receipt_new_v2"
    )

  end
end
