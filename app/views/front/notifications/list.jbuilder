json.array! @notifications do |notification|
  json.merge! notification.attributes
  json.notification_tags do
    json.array! notification.notification_tags.order(order: :asc) do |tag|
      json.merge! tag.attributes
    end if notification.notification_tags.present?
  end
end
 