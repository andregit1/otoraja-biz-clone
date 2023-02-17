class Console::NotificationsController < Console::ApplicationConsoleController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  def index
    @notifications = Notification.all.order("id DESC").page(params[:page]).per(10)
  end

  def new
    @notification = Notification.new
  end

  def edit
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      redirect_to console_notifications_path, flash: {info: 'Notification was successfully created.'}
    else
      render :new
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to console_notifications_path, flash: {info: 'Notification was successfully updated.'}
    else
      render :edit
    end
  end

  def destroy
    @notification.destroy
    redirect_to console_notifications_path, flash: {info: 'Notification was successfully destroyed.'}
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(
        :subject,
        :body,
        :published_from,
        :published_to,
        :status,
        notification_tag_relations_attributes:[
          :id,
          :notification_tag_id,
          :_destroy,
        ],
        :shop_ids => [],
      )
    end
end
