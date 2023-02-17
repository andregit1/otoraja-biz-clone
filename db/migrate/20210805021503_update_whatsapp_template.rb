class UpdateWhatsappTemplate < ActiveRecord::Migration[5.2]
  def change
    service = WhatsAppService.find_by(name: "Receipt")
    # customer purchase
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_reminder_purchase_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_reminder_purchase_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_reminder_purchase_new_v1"
    )
    # customer quetionnairre
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_questionnairre_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_questionnairre_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_questionnairre_new_v1"
    )

    # customer receipt
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_receipt_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_receipt_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_receipt_new_v1"
    )

    # customer register
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_register_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_register_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_register_new_v1"
    )

    # customer reminder
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:production],
      template_name: "otoraja_customer_reminder_service_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:staging],
      template_name: "otoraja_customer_reminder_service_new_v1"
    )
    WhatsAppTemplate.create(
      whats_app_service_id: service.id,
      environment: WhatsAppTemplate.environmentTypes[:development],
      template_name: "otoraja_customer_reminder_service_new_v1"
    )

  end
end
