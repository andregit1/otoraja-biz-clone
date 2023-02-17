class Console::TechSpecsController < Console::ApplicationConsoleController
  before_action :set_tech_spec, only:[:edit, :update]

  def index
    @q = TechSpec.ransack(params[:q])
    @tech_specs = @q.result
  end
  
  def new
    @tech_spec = TechSpec.new()
  end
  
  def create
    @tech_spec = TechSpec.new(tech_spec_params)
    if @tech_spec.duplicateTechSpecName?(tech_spec_params[:name],tech_spec_params[:product_category_id], params[:id] )
      render :new
    else
      if @tech_spec.save
        redirect_to console_tech_specs_path, notice: I18n.t('tech_spec.notice.successful_tech_spec_saved')
      else
        render :new
      end
    end
  end

  def edit
  end
    
  def update
    if @tech_spec.duplicateTechSpecName?(tech_spec_params[:name],tech_spec_params[:product_category_id], params[:id] )
      render :edit
    else
      if @tech_spec.update(tech_spec_params)
        redirect_to console_tech_specs_path, notice: I18n.t('tech_spec.notice.successful_tech_spec_updated')
      else
        render :edit
      end
    end
  end

  def edit_multiple
    TechSpec.update(params[:tech_specs].keys, params[:tech_specs].values)
    redirect_to console_tech_specs_path, notice: I18n.t('tech_spec.notice.successful_tech_spec_updated')
  end
  
  private

  def tech_spec_params
    params.require(:tech_spec).permit(:name, :product_category_id)
  end

  def set_tech_spec
    @tech_spec = TechSpec.find(params[:id])
  end
end
