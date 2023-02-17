class AddSubscriptionAccountSuspendWhatsappTemplate < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Subscription")
  
      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "subscription_account_suspended_v2"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "subscription_account_suspended_v2"
      )

      WhatsAppTemplate.create(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "subscription_account_suspended_v2"
      )
    end
  end

  def down
    ActiveRecord::Base.transaction do 
      service = WhatsAppService.find_by(name: "Subscription")
  
      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:production],
        template_name: "subscription_account_suspended_v2"
      ).delete

      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:staging],
        template_name: "subscription_account_suspended_v2"
      ).delete

      WhatsAppTemplate.where(
        whats_app_service_id: service.id,
        environment: WhatsAppTemplate.environmentTypes[:development],
        template_name: "subscription_account_suspended_v2"
      ).delete
    end
  end
end
