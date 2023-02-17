class SeedWhatsAppTemplates < ActiveRecord::Migration[5.2]
  def change
    WhatsAppService.create(name: "Subscription")
    templates = [
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_bank_account_created'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_expired'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_payment_received'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_bank_account_created'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_application_received'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_cancelled'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_unpaid'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_renewal_billing_issued'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_account_suspended'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_resubscribe'],
        [whats_app_service_id: 2, environment: 2, template_name: 'subscription_renew'],
    ]

    WhatsAppTemplate.create(templates)
  end
end
