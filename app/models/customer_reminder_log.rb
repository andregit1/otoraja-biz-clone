class CustomerReminderLog < ApplicationRecord
  belongs_to :send_message
  belongs_to :customer
  belongs_to :checkin, optional: true
  belongs_to :campaign, optional: true
end
