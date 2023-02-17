class Console::VariantsController < Console::ApplicationConsoleController
  def index
    @q = Variant.ransack(params[:q])
    @variants = @q.result
  end

  def new
    @variant = Variant.new()
  end

  def create
    @variant = Variant.new(variant_params)
    if @variant.duplicateVariantName?(variant_params[:name],variant_params[:product_category_id])
      render :new
    else
      if @variant.save
        redirect_to console_variants_path, notice: I18n.t('variant.notice.successful_variant_saved')
      else
        render :new
      end
    end
  end

  def edit
    @variant = Variant.find(params[:id])
  end

  def update
    @variant = Variant.find(params[:id])
    if @variant.duplicateVariantName?(variant_params[:name],variant_params[:product_category_id], params[:id] )
      render :edit
    else
      if @variant.update(variant_params)
        redirect_to console_variants_path, notice: I18n.t('variant.notice.successful_variant_updated')
      else
        render :edit
      end
    end
  end

  def edit_multiple
    Variant.update(params[:variants].keys, params[:variants].values)
    redirect_to console_variants_path, notice: I18n.t('variant.notice.successful_variant_updated')
  end

  private
  def variant_params
    params.require(:variant).permit(:name, :product_category_id)
  end
end