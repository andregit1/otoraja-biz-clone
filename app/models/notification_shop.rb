class NotificationShop < ApplicationRecord
  belongs_to :notification
  belongs_to :shop
end
