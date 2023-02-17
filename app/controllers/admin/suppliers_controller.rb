class Admin::SuppliersController < Admin::ApplicationAdminController
  before_action :build_country_code_list, only:[:new, :edit, :create, :update]

  def index
    @q = policy_scope(Supplier).eager_load(:shop).where(shop_id: session[:default_user_shop]).order('shop_id ASC').ransack(params[:q])
    @suppliers = @q.result.page(params[:page]).per(10)
  end

  def new
    @supplier = Supplier.new()
  end

  def edit
    begin
      @supplier = policy_scope(Supplier).find(params[:id])
      phone = Phonelib.parse(@supplier.tel)
      @phone_country_code = phone.country_code || '62'
      @phone_national = phone.national(false)  
    rescue => exception
      redirect_to admin_suppliers_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def create
    @supplier = Supplier.new(supplier_params)
    tel = get_tel()
    @supplier.tel = tel

    if @supplier.save
      redirect_to admin_suppliers_path, notice: I18n.t('supplier.notice.successful_supplier_created')
    else
      flash.now[:danger] = I18n.t('supplier.notice.unsuccessful_supplier_created')
      render :new
    end
  end
  
  def update
    begin
      @supplier = policy_scope(Supplier).find(params[:id])
      tel = get_tel()
      @supplier.tel = tel
      if @supplier.update(supplier_params)
        redirect_to admin_suppliers_path, notice: I18n.t('supplier.notice.successful_supplier_updated')
      else
        flash.now[:danger] = I18n.t('supplier.notice.unsuccessful_supplier_created')
        render :edit
      end
    rescue => exception
      redirect_to admin_suppliers_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  def destroy
    @supplier = policy_scope(Supplier).find(params[:id])
    @supplier.discard
    redirect_to admin_suppliers_path, notice: I18n.t('supplier.notice.successful_supplier_destroyed')
  end

  private
    def supplier_params
      params.fetch(:supplier, {}).permit(:name,:shop_id,:address)
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
