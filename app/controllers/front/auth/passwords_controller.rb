# frozen_string_literal: true

class Front::Auth::PasswordsController < DeviseTokenAuth::PasswordsController
  protect_from_forgery :except => [:update_without_token]
  before_action :off_save_session
  after_action :on_save_session

  def update_without_token
    @user = current_user
    @user.password_updated_at = DateTime.now

    if user_password_params[:password].blank?
      response_unauthorized
    end
    
    if @user.update_with_password(user_password_params)
      bypass_sign_in @user, scope: resource_name
      response_no_content
    else
      response_unauthorized
    end
  end

private
  def user_password_params
    params.require(:user).permit(:id, :password, :password_confirmation, :current_password)
  end

  def off_save_session
    @ignore_save_session = true
  end

  def on_save_session
    @ignore_save_session = false
  end

  # 204 Created
  def response_no_content
    render status: 204, json: { status: 204, message: 'No Content' }
  end

  # 401 Unauthorized
  def response_unauthorized
    render status: 401, json: { status: 401, message: 'Unauthorized' }
  end
end
