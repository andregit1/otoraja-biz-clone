class AddWhatsappTemplateFrontShop < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Receipt")

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_checkin_first"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_checkin_first"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_checkin_first"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_reminder_customer"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_reminder_customer"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_reminder_customer"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_reminder_purchase"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_reminder_purchase"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_reminder_purchase"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_receipt_send"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_receipt_send"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_receipt_send"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_questionnaire_thank_you"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_questionnaire_thank_you"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_questionnaire_thank_you"
      )
    end
  end
end
