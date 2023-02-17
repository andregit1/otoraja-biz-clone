class WhatsAppInvite < ApplicationRecord
  has_one :whats_app_service
  belongs_to :customer
end
