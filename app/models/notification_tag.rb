class NotificationTag < ApplicationRecord
  has_many :notification_tag_relations
  has_many :notifications, :through => :notification_tag_relations
end
