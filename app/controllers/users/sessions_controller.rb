# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :validation_role, only: [:create]
  prepend_before_action :validate_token, only: [:new]
  layout 'devise'

  def after_sign_in_path_for(resource)
    if resource.password_updated_at.nil?

      token = Token.find_by(customer_id: resource.id)
      token.destroy if token.present?

      user_password_change_path
    elsif resource.staff?
      sign_out
      flash[:danger] = 'Anda tidak dapat login di sini. Silakan gunakan aplikasi Otoraja.'
      new_user_session_path
    else
      unless session[:redirect_url].present?
        admin_dashboard_index_path
      else
        session[:redirect_url]
        session.delete(:redirect_url)
      end
    end
  end

  private

  def validation_role
    @user = User.search_by_userid_or_email(user_params[:user_id])
    if @user.nil?
      redirect_to new_user_session_path, flash: {danger: I18n.t('admin.notification.custom_failure_message')}
    elsif @user.admin_roles?
      redirect_to new_user_session_path and return
    end
  end

  def validate_token
    if params["uuid"].present?
      token = Token.find_by(uuid: params["uuid"])
      if token&.is_expired 
        #remove user record, remove related shop, shop group, request record. 
        #redirect to signup page with notification of expired status
        #ShopGroup.remove_shop_application(token.customer_id)
        token.destroy
        redirect_to new_user_session_path, flash: {danger: I18n.t('token_expired')}
      elsif token.nil?
        redirect_to new_user_session_path
      end
    end
  end

  def user_params
    params.require(:user).permit(:user_id, :password, :remember_me, :otp_attempt, :uuid)
  end

end
