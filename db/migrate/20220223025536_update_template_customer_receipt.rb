class UpdateTemplateCustomerReceipt < ActiveRecord::Migration[5.2]
  def change
    service = WhatsAppService.find_by(name: "Receipt")
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: 2,
      template_name: :otoraja_customer_receipt_new_v4
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: 1,
      template_name: :otoraja_customer_receipt_new_v4
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: 0,
      template_name: :otoraja_customer_receipt_new_v4
    )
  end
end
