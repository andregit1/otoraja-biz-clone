class Front::NotificationsController < Front::ApiController
  def list
    @notifications = policy_scope(Notification).published
    @checked_tags = params[:tags] || NotificationTag.all.ids
    @checked_tags = @checked_tags.push(nil)
    @notifications = @notifications.left_joins(:notification_tags).where('notification_tag_relations.notification_tag_id': @checked_tags).distinct
    order = params[:order] || 'published_from desc'
    @notifications = @notifications.order(order).order(id: :desc)
    @notifications = @notifications.limit(params[:limit]) if params[:limit].present?
  end

  def tags
    @tags = NotificationTag.order(order: :asc)
  end

  def except_check_token_action
    ['tags']
  end
end
