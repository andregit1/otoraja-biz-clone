class ProductReminderLog < ApplicationRecord
  belongs_to :send_message
  belongs_to :maintenance_log_detail
  belongs_to :campaign, optional: true
end
