class Front::GeneralController < Front::ApiController
  def release_note_path
  end

  def version
    @version = Version.all.first
  end

  def notifications
    order = params[:order] || 'published_from desc'
    @notifications = policy_scope(Notification).published.order(order).order(id: :desc)
    @notifications = @notifications.limit(params[:limit]) if params[:limit].present?
  end

  def user_info
    if current_user.present?
      @user = current_user
    else
      response_unauthorized
    end
  end

  def except_check_token_action
    ['release_note_path', 'version']
  end
end