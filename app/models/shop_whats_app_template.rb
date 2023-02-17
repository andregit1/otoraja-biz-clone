class ShopWhatsAppTemplate < ApplicationRecord
  belongs_to :shop
  has_many :whats_app_templates
end
