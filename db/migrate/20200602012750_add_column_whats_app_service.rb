class AddColumnWhatsAppService < ActiveRecord::Migration[5.2]
  def change
    add_column :whats_app_services, :whats_app_template_id, :bigint, :after => 'id'
  
    service = WhatsAppService.create(name:"Receipt", whats_app_template_id: 1)
    WhatsAppTemplate.create(template_name: "otoraj_send_receipt_msg", whats_app_service_id: service.id, environment: WhatsAppTemplate.environmentTypes[:production])
    WhatsAppTemplate.create(template_name: "otoraj_send_receipt_msg_stg", whats_app_service_id: service.id, environment: WhatsAppTemplate.environmentTypes[:staging])
    WhatsAppTemplate.create(template_name: "otoraj_send_receipt_msg_dev", whats_app_service_id: service.id, environment: WhatsAppTemplate.environmentTypes[:development])
  end
end
