class AddCostEstimationWhatsappTemplate < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Receipt")
  
      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_customer_cost_estimation_v3"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_customer_cost_estimation_v3"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_customer_cost_estimation_v3"
      )
    end
  end

  def down
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Receipt")
  
      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "otoraja_customer_cost_estimation_v3"
      ).delete

      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "otoraja_customer_cost_estimation_v3"
      ).delete

      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "otoraja_customer_cost_estimation_v3"
      ).delete
    end
  end
end
