class Console::ShopStaffsController < Console::ApplicationConsoleController
  before_action :set_shops, only:[:new, :edit, :create, :update]

  def index
    @q = ShopStaff.ransack(params[:q])
    @shop_staffs = policy_scope(@q.result).order("id DESC")
    @shops = current_user.managed_shops
  end

  def new
    @shop_staff = ShopStaff.new()
  end

  def edit
    @shop_staff = ShopStaff.find(params[:id])
  end

  def create
    @shop_staff = ShopStaff.new(shopstaff_params)
    if @shop_staff.save
      if @shop_id.present?
        redirect_to console_shop_path(Shop.find(@shop_id)), notice: 'ShopStaff was successfully created.' 
      else
        redirect_to console_shop_staffs_path, notice: 'ShopStaff was successfully created.' 
      end
    else
      render :new
    end
  end
  
  def update
    @shop_staff = ShopStaff.find(params[:id])
    if @shop_staff.update(shopstaff_params)
      redirect_to console_shop_staffs_path, notice: 'ShopStaff was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @shop_staff = ShopStaff.find(params[:id])
    @shop_staff.destroy
    redirect_to console_shop_staffs_path, notice: 'Supplier was successfully destroyed.'
  end

  private
    def shopstaff_params
      params.fetch(:shop_staff, {}).permit(:name,:shop_id,:is_front_staff,:is_mechanic,:mechanic_grade,:active)
    end

    def set_shops
      @shop_id ||= params[:shop_id]
      if @shop_id.present?
        @shops = policy_scope(Shop).where(id: @shop_id)
      else
        @shops = policy_scope(Shop).all
      end
    end
end
