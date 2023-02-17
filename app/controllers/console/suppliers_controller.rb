class Console::SuppliersController < Console::ApplicationConsoleController
  before_action :set_shops, only:[:new, :edit, :create, :update]
  before_action :build_country_code_list, only:[:new, :edit, :create, :update]

  def index
    @q = policy_scope(Supplier).eager_load(:shop).order('shop_id ASC').ransack(params[:q])
    @suppliers = @q.result
  end

  def new
    @supplier = Supplier.new()
  end

  def edit
    @supplier = Supplier.find(params[:id])
    phone = Phonelib.parse(@supplier.tel)
    @phone_country_code = phone.country_code || '62'
    @phone_national = phone.national(false)
  end

  def create
    @supplier = Supplier.new(supplier_params)
    tel = get_tel()
    @supplier.tel = tel

    if @supplier.save
      redirect_to console_suppliers_path, notice: 'Supplier was successfully created.' 
    else
      render :new
    end
  end
  
  def update
    @supplier = Supplier.find(params[:id])
    tel = get_tel()
    @supplier.tel = tel
    if @supplier.update(supplier_params)
      redirect_to console_suppliers_path, notice: 'Supplier was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.discard
    redirect_to console_suppliers_path, notice: 'Supplier was successfully destroyed.'
  end

  private
    def supplier_params
      params.fetch(:supplier, {}).permit(:name,:shop_id,:address)
    end

    def set_shops
      @maintenance_log = MaintenanceLog.find_by(checkin_id: params[:checkin_id])
      @shops = current_user.shops
    end

    def build_country_code_list
      @country_code_list = {
        '+1' => '1',
        '+62' => '62',
        '+81' => '81'
      }
    end

    def get_tel
      permited_params = params.fetch(:supplier, {}).permit(:phone_country_code, :phone_national)
      @phone_country_code = permited_params[:phone_country_code]
      @phone_national = permited_params[:phone_national]
      tel = permited_params[:phone_country_code] + permited_params[:phone_national] unless permited_params[:phone_national].empty?
      phone = Phonelib.parse(tel)
      phone.international(false)
    end

end
