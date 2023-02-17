class WhatsAppService < ApplicationRecord
  has_many :whats_app_templates, :through => :shop_whats_app_templates
  has_many :shop_whats_app_templates
  has_many :whats_app_templates
end
