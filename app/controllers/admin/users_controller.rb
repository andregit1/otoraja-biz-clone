class Admin::UsersController < Admin::ApplicationAdminController

  before_action :available_roles

  def index
    begin
      @users = policy_scope(User)
      #roleが指定されている場合
      @users = @users.where(role: params[:role]) if params[:role].present?
      #shop_idが指定されている場合
      @users = @users.joins(:shops).where(shops: {id: params[:shop_id]}) if params[:shop_id].present?
      @users = @users.page(params[:page]).per(10).order(id: :asc).distinct

      authorize @users
    rescue => exception
      redirect_to root_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def show
    begin
      @user = policy_scope(User).find(params[:id])
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def new
    begin
      @shop_id ||= params[:shop_id]
      @user = User.new
      authorize @user

      @user.role = params[:role] if params[:role].present?
      @user.shops << Shop.find(params[:shop_id]) if params[:shop_id].present?
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def edit
    begin
      @user = policy_scope(User).find(params[:id])
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def create
    @user = User.new(user_params)
    user_id = User.generate_employee_user_id(user_params[:user_id],current_user.shop_group_no)
    @user.uid = user_id
    @user.user_id = user_id
    @user.shops = [Shop.find_by(id: user_params[:shop_ids])]

    if @user.save
      if get_shop_id[:shop_id].present?
        redirect_to admin_shops_show_path(id: get_shop_id[:shop_id]), flash: {success: 'User was successfully created.'}
      else
        redirect_to admin_users_path, flash: {success: 'User was successfully created.'}
      end
    else
      @user.user_id = @user.user_id.sub!(/@.*/m, "")
      render :new
    end
  end

  def update
    begin
      @user = policy_scope(User).find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def destroy
    begin
      @user = policy_scope(User).find(params[:id])
      if current_user != @user
        @user.destroy
      end
      redirect_to admin_users_path, notice: 'User was successfully destroyed.'
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def disable_user
    begin
      @user = policy_scope(User).find(params[:id])
      update_user_status('disabled')
      redirect_to admin_users_path
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def enable_user
    begin
      @user = policy_scope(User).find(params[:id])
      update_user_status('enabled')
      redirect_to admin_users_path
    rescue => exception
      redirect_to admin_users_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def password
    @user = policy_scope(User).find(params[:id])
  end

  def password_update
    @user = policy_scope(User).find(user_password_params[:id])
    @user.password_updated_at = DateTime.now

    if user_password_params[:password].blank?
      @user.errors.add(:password, :blank)
      render :password
      return
    end
    
    if current_user.owner?
      result = @user.update_without_current_password(user_password_params)
    else
      result = @user.update_with_password(user_password_params)
    end

    if result
      redirect_to admin_users_path
    else
      render :password
    end
  end

  private
    def user_params
      params.fetch(:user, {}).permit(:name, :user_id, :role, :password, :status, :export_pattern_id,:shop_ids)
    end

    def user_password_params
      params.require(:user).permit(:id, :password, :password_confirmation, :current_password)
    end

    def get_shop_id
      params.fetch(:user, {}).permit(:shop_id)
    end

    def available_roles
      @roles = ['manager', 'staff', 'shop_manager']
      @roles << 'owner' if current_user.admin_roles?
      @roles << 'admin_operator' if current_user.admin_roles?
      @roles << 'admin' if current_user.admin?
    end

    def update_user_status(status)
      @user.status = status
      @user.save
    end
end
