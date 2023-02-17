class CampaignType < ApplicationRecord
  belongs_to :reminder_body_template, optional: true
  
  enum code_type: { product_remind: 0, customer_remind: 1 }
end
