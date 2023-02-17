class ChangeSubscriptionPaymentReceive < ActiveRecord::Migration[5.2]
  def change
    templates = [
        [
          whats_app_service_id: 2, 
          environment: WhatsAppTemplate.environmentTypes[:production], 
          template_name: 'otoraja_subscription_payment_received'
        ],
        [
          whats_app_service_id: 2, 
          environment: WhatsAppTemplate.environmentTypes[:staging], 
          template_name: 'otoraja_subscription_payment_received'
        ],
        [
          whats_app_service_id: 2, 
          environment: WhatsAppTemplate.environmentTypes[:development], 
          template_name: 'otoraja_subscription_payment_received'
        ]
    ]

    WhatsAppTemplate.create(templates)
  end
end

