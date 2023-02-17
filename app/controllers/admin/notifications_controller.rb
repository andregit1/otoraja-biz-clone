
class Admin::NotificationsController < Admin::ApplicationAdminController
  
  def index
    begin
      @notifications = policy_scope(Notification).where('notification_shops.shop_id': session[:default_user_shop]).published
      @checked_tags = params[:tag].present? ? params[:tag] : NotificationTag.all.ids.push(nil)
      @notifications = @notifications.left_joins(:notification_tags).where('notification_tag_relations.notification_tag_id': @checked_tags).distinct
      @current_sort = params[:sort]
      order = Notification.sort_condition[@current_sort&.to_sym] || 'published_from DESC, id DESC'
      @notifications = @notifications.order(order)
      @notifications = @notifications.page(params[:page]).per(10)
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def show
    begin
      @notification = policy_scope(Notification).where('notification_shops.shop_id': session[:default_user_shop]).published.find(params[:id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

end
