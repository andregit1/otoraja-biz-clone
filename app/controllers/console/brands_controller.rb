class Console::BrandsController < Console::ApplicationConsoleController
  before_action :set_brand, only:[:edit, :update]
  
  def index
    @q = Brand.ransack(params[:q])
    @brands = @q.result
  end
    
  def new
    @brand = Brand.new()
  end
    
  def create
    @brand = Brand.new(brand_params)
    if @brand.duplicateBrandName?(brand_params[:name])
      render :new
    else
      if @brand.save
        redirect_to console_brands_path, notice: I18n.t('brand.notice.successful_brand_saved')
      else
        render :new
      end
    end
  end
  
  def edit
  end
      
  def update
    if @brand.duplicateBrandName?(brand_params[:name], params[:id] )
      render :edit
    else
      if @brand.update(brand_params)
        redirect_to console_brands_path, notice: I18n.t('brand.notice.successful_brand_updated')
      else
        render :edit
      end
    end
  end

  def edit_multiple
    Brand.update(params[:brands].keys, params[:brands].values)
    redirect_to console_brands_path, notice:  I18n.t('brand.notice.successful_brand_updated')
  end
    
  private
  
  def brand_params
    params.require(:brand).permit(:name)
  end
  
  def set_brand
    @brand = Brand.find(params[:id])
  end
end
