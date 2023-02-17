class Console::UsersController < Console::ApplicationConsoleController

  before_action :available_roles

  def index
    @q = policy_scope(User).left_joins(:shops).ransack(params[:q])
    @users = @q.result.order(id: :asc).page(params[:page]).per(10).distinct
  end

  def new
    @shop_id ||= params[:shop_id]
    @user = User.new
    @user.user_id = params[:user_id] if params[:user_id].present?
    @user.name = params[:name] if params[:name].present?
    @user.role = params[:role] if params[:role].present?
    if @user.role.present? && @user.role == 'owner'
      @user.email = @user.user_id
    end
    @user.shops << Shop.find(params[:shop_id]) if params[:shop_id].present?
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if user_params[:role] == 'owner'
      @user.user_id = @user.email
    end
    @user.uid = @user.user_id

    if @user.save
      if get_shop_id[:shop_id].present?
        redirect_to console_shop_path(id: get_shop_id[:shop_id]), flash: { success: 'User was successfully created.'}
      else
        redirect_to console_users_path, flash: { success: 'User was successfully created.'}
      end
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to console_users_path, flash: { success: 'User was successfully updated.'}
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user != @user
      @user.destroy
    end
    redirect_to console_users_path, flash: { success: 'User was successfully destroyed.'}
  end

  def disable_user
    @user = User.find(params[:id])
    update_user_status('disabled')
    redirect_to console_users_path
  end

  def enable_user
    @user = User.find(params[:id])
    update_user_status('enabled')
    redirect_to console_users_path
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
    
    if @user.update_without_current_password(user_password_params)
      redirect_to console_users_path, flash: {success: 'User Password was successfully updated.'}
    else
      render :password
    end
  end

  private
    def user_params
      params.fetch(:user, {}).permit(:name, :user_id, :email, :role, :password, :status, :export_pattern_id,{shop_ids: []})
    end

    def user_password_params
      params.require(:user).permit(:id, :password, :password_confirmation, :current_password)
    end

    def get_shop_id
      params.fetch(:user, {}).permit(:shop_id)
    end

    def available_roles
      @roles = ['manager', 'staff', 'shop_manager', 'owner']
      @roles << 'admin_operator' if current_user.admin_roles?
      @roles << 'admin' if current_user.admin?
    end

    def update_user_status(status)
      @user.status = status
      @user.save
    end

end
