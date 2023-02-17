class ApplicationController < ActionController::Base
  layout 'application'
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :staff_list, if: :user_signed_in?
  before_action :set_current_staff
  before_action :confirm_password_reset, unless: :devise_controller?
  add_flash_types :success, :info, :warning, :danger
  after_action :set_session_shop_id, if: :user_signed_in?

  def append_info_to_payload(payload)
    super
    if @exception.present?
      payload[:exception_object] ||= @exception
      payload[:exception] ||= [@exception.class, @exception.message]
    end
    payload[:region] ||= ENV['AWS_DEFAULT_REGION']
  end

  def current_staff_id
    session[:current_staff_id]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:user_id, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  private
    def staff_list
      @staff_list = policy_scope(ShopStaff).active_front_staffs
    end

    def set_current_staff
      if params[:current_staff_id].present?
        staff = ShopStaff.where(shop: current_user.shops).find_by(id: params[:current_staff_id])
        session[:current_staff_id] = params[:current_staff_id] unless staff == nil
      end
      ShopStaff.current_staff = ShopStaff.find(session[:current_staff_id]) if session[:current_staff_id]
    end

    def set_session_shop_id 
      ApplicationController.helpers.get_current_shop_session(session, current_user)
    end

    def confirm_password_reset
      redirect_to user_password_change_path if current_user.present? && !current_user.admin_roles? && current_user.password_updated_at.nil?
    end

end
