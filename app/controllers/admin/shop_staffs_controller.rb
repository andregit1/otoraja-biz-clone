class Admin::ShopStaffsController < Admin::ApplicationAdminController
  before_action :set_shops, only:[:new, :edit, :create, :update]

  def index
    @q = policy_scope(ShopStaff).where(shop_id: session[:default_user_shop]).order("id DESC").ransack(params[:q])
    @shop_staffs = @q.result.page(params[:page]).per(10)
    @shops = current_user.managed_shops.where(shop_id: session[:default_user_shop])
  end

  def new
    @shop_staff = ShopStaff.new()
  end

  def edit
    begin
      @shop_staff = policy_scope(ShopStaff).find(params[:id])
    rescue => exception
      redirect_to admin_shop_staffs_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def create
    @shop_staff = ShopStaff.new(shopstaff_params)
    if @shop_staff.save
      redirect_to admin_shop_staffs_path, notice: 'ShopStaff was successfully created.' 
    else
      flash.now[:danger] = 'Nama terlalu panjang (maksimum 45 karakter)' 
      render :new
    end
  end
  
  def update
    begin
      @shop_staff = policy_scope(ShopStaff).find(params[:id])
      if @shop_staff.update(shopstaff_params)
        redirect_to admin_shop_staffs_path, notice: 'ShopStaff was successfully updated.'
      else
        flash.now[:danger] = 'Nama terlalu panjang (maksimum 45 karakter)'
        render :edit
      end
    rescue => exception
      redirect_to admin_shop_staffs_path, flash: {danger: I18n.t('reject_access')}
    end
    
  end

  def destroy
    begin
      @shop_staff = policy_scope(ShopStaff.find(params[:id]))
    rescue => exception
      redirect_to admin_shop_staffs_path, flash: {danger: I18n.t('reject_access')}
    end
    @shop_staff.destroy
    redirect_to admin_shop_staffs_path, notice: 'Supplier was successfully destroyed.'
  end

  private
    def shopstaff_params
      params.fetch(:shop_staff, {}).permit(:name,:shop_id,:is_front_staff,:is_mechanic,:mechanic_grade,:active)
    end

    def set_shops
      @shops = current_user.shops
    end
end
