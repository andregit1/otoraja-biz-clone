class Console::ApplicationConsoleController < ActionController::Base
  include Pundit

  protect_from_forgery
  before_action :authenticate_user!
  before_action :check_admin_authority
  layout 'console/application_admin'

  def policy_scope(scope)
    super([:console, scope])
  end

  def authorize(record, query = nil)
    super([:console, record], query)
  end

  def append_info_to_payload(payload)
    super
    if @exception.present?
      payload[:exception_object] ||= @exception
      payload[:exception] ||= [@exception.class, @exception.message]
    end
    payload[:region] ||= ENV['AWS_DEFAULT_REGION']
  end

  private
    def check_admin_authority
      authorize User, :access_admin?
    end
end
