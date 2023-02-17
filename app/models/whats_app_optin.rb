class WhatsAppOptin < ApplicationRecord
  has_one :whats_app_service
  has_one :whats_app_invite
  belongs_to :customer
end
