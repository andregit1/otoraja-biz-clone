class Admin::ApplicationAdminController < ActionController::Base
  include Pundit
  
  protect_from_forgery
  before_action :authenticate_user!
  before_action :check_admin_authority
  before_action :set_notification
  before_action :confirm_password_reset, unless: :devise_controller?
  layout 'admin/application_admin'

  def policy_scope(scope)
    super([:admin, scope])
  end

  def authorize(record, query = nil)
    super([:admin, record], query)
  end

  def append_info_to_payload(payload)
    super
    if @exception.present?
      payload[:exception_object] ||= @exception
      payload[:exception] ||= [@exception.class, @exception.message]
    end
    payload[:region] ||= ENV['AWS_DEFAULT_REGION']
  end

  def set_notification
    @global_notification = policy_scope(Notification).published.last
  end
  
  private
    def check_admin_authority
      authorize User, :access_admin?
    end

    def confirm_password_reset
      redirect_to user_password_change_path if !current_user.admin_roles? && current_user.password_updated_at.nil?
    end

    def authenticate_user!
      session[:redirect_url] = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      redirect_to new_user_session_path unless user_signed_in?
    end
end
