# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :require_no_authentication, only: [:change, :update_without_token]

  layout 'devise'

  def change
    @user = current_user
  end

  def update_without_token
    @user = current_user
    @user.password_updated_at = DateTime.now

    if user_password_params[:password].blank?
      @user.errors.add(:password, :blank)
      render :change
      return
    end
    
    if @user.update_with_password(user_password_params)
      bypass_sign_in @user, scope: resource_name

      if @user.staff?
        sign_out
        redirect_to new_user_session_path, flash: {danger: 'Anda tidak dapat login di sini. Silakan gunakan aplikasi Otoraja.'}
      else
        redirect_to admin_dashboard_index_path
      end
    else
      render :change
    end

  end

  private
    def user_password_params
      params.require(:user).permit(:id, :password, :password_confirmation, :current_password)
    end

    def authenticate_user!
      redirect_to new_user_session_path unless user_signed_in?
    end
end
