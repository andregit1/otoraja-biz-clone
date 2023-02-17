# frozen_string_literal: true

class ManagementUsers::SessionsController < Devise::SessionsController
  # prepend_before_action :authenticate_with_two_factor, only: [:create_mgr]
  # before_action :validate_two_factor, only: [:new, :new_mgr]
  prepend_before_action :allow_params_authentication!, only: [:create, :create_mgr]
  prepend_before_action :validation_role, only: [:create, :create_mgr]
  layout 'devise'

  def after_sign_in_path_for(resource)
    console_dashboard_index_path
  end

  def after_sign_out_path_for(resource)
    new_management_session_path
  end

  def new_mgr
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end
  
  def create_mgr
    auth_options = { scope: :user, recall: "management_users/sessions#new_mgr"}
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  
  private

  def validation_role
    @user = User.search_by_userid_or_email(user_params[:user_id])
    if @user.nil? || !@user.admin_roles?
      redirect_to new_management_session_path and return
    end
  end

  def authenticate_with_two_factor

    return if user_params[:user_id].blank?

    @user = User.search_by_userid_or_email(user_params[:user_id])
    self.resource = @user

    return unless @user && @user.otp_required_for_login
    
    if @user.valid_password?(user_params[:password])
      session[:otp_user_id] = @user.user_id
      redirect_to(new_console_two_factor_auth_path) and return
    end
  end

  def validate_two_factor

    return unless session[:otp_user_id] && session[:otp_attempt]

    @user = User.find_by(user_id: session[:otp_user_id])
    if @user.validate_and_consume_otp!(session[:otp_attempt])
      session.delete(:otp_user_id)
      session.delete(:otp_attempt)
      sign_in(@user) 
      redirect_to(console_dashboard_index_path) and return
    else
      session[:mfa_error] = 'Invalid Code'
      redirect_to(new_console_two_factor_auth_path) and return
    end
  end

  def user_params
    params.require(:user).permit(:user_id, :password, :remember_me, :otp_attempt)
  end

end
