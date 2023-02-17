class NotificationTagRelation < ApplicationRecord
  belongs_to :notification
  belongs_to :notification_tag
end
