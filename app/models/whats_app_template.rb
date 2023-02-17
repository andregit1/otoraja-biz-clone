  class WhatsAppTemplate < ApplicationRecord
    belongs_to :whats_app_service

    enum environmentType: {development:0, staging:1,production:2}
    enum names: {
      subscription_application_received:0, 
      subscription_bank_account_created:1, 
      subscription_payment_received:2, 
      subscription_renew:3, 
      subscription_expired:4, 
      subscription_cancelled:5, 
      subscription_resubscribe:6, 
      subscription_account_suspended:7, 
      subscription_renewal_billing_issued:8, 
      subscription_unpaid:9,
      otoraja_stock_reminder: 10,
      otoraja_checkin_first: 11,
      otoraja_reminder_customer: 12,
      otoraja_reminder_purchase: 13,
      otoraja_receipt_send: 14,
      otoraja_questionnaire_thank_you: 15,
      otoraja_subscription_payment_received: 16,
      otoraja_receipt_checkout: 17,
      otoraja_my_page_send_otp: 18,
      otoraja_customer_questionnairre_new_v1: 19,
      otoraja_customer_reminder_purchase_new_v1: 20,
      otoraja_customer_reminder_service_new_v1: 21,
      otoraja_customer_register_new_v1: 22,
      otoraja_customer_receipt_new_v1: 23,
      otoraja_customer_receipt_new_v2: 24,
      otoraja_change_phone_number_v1: 25,
      subscription_account_suspended_v2: 26,
      otoraja_customer_cost_estimation_v3: 27,
      otoraja_down_payment_receipt_v1: 28,
      otoraja_customer_receipt_new_v4: 29,
      daily_stock_notification: 30
    }
    
    validates :template_name, presence: true

    scope :get_production_templates, -> {
      WhatsAppTemplate.joins(:whats_app_service).where(environment: WhatsAppTemplate.environmentTypes[:production]).select("whats_app_templates.*, whats_app_services.name as service_name")
    }

    scope :get_template_by_id, ->(service_id) {
      WhatsAppTemplate.where(whats_app_service_id: service_id, environment: get_env).first
    }

    class << self
      def get_template_by_name(template_number) 
        name = WhatsAppTemplate.names.key(template_number)
        WhatsAppTemplate.where(template_name: name, environment: get_env).first
      end
    end

    private
    class << self
      def get_env()
        if Rails.env.production?
          WhatsAppTemplate.environmentTypes[:production]
        elsif Rails.env.staging?
          WhatsAppTemplate.environmentTypes[:staging]
        elsif Rails.env.development?
          WhatsAppTemplate.environmentTypes[:development]
        end
      end
    end
  end
