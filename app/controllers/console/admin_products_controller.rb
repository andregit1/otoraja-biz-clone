class Console::AdminProductsController < Console::ApplicationConsoleController
  def index
    @shops = current_user.managed_shops
    @default_shop = policy_scope(Shop).find_by(id: params[:shop_id])
    @select_shop = @default_shop || @shops.first
    @product_categories = ProductCategory.joins(:admin_products).distinct.order(id: :asc)
  end

  def import
    @admin_product_upload = AdminProductUpload.new
  end

  def import_confirm
    @admin_product_upload = AdminProductUpload.new(admin_product_upload_params)
    if @admin_product_upload.valid?
      @admin_products = @admin_product_upload.get_admin_products
      @old_admin_products = @admin_product_upload.get_old_admin_products
      @admin_product_collection = AdminProductCollection.new
      @edit_products = @old_admin_products.compact.count
      @add_products = @admin_products.count - @edit_products
    else
      render :import
    end
  end

  def import_execution
    @admin_products = admin_product_collection_params[:admin_products].values
    @admin_product_collection = AdminProductCollection.new(@admin_products)
    additional_admin_product_params = @admin_products.map { |h| h.slice(:brand_name, :variant_name, :tech_spec_name) }

    if @admin_product_collection.save(additional_admin_product_params)
      redirect_to console_admin_products_import_path, flash: {info: 'Product import successful.'}
    else
      redirect_to console_admin_products_import_path, flash: {danger: 'Product import failed.'}
    end
  end

  def template_export
    @admin_products = AdminProduct.eager_load(:product_category, :brand, :variant, :tech_spec).order(id: :asc)
    @product_categories = ProductCategory.all.order(id: :asc)
    @brands = Brand.all.order(id: :asc)
    @variants = Variant.eager_load(:product_category).order(id: :asc)
    @tech_specs = TechSpec.eager_load(:product_category).order(id: :asc)

    respond_to do |format|
      format.xlsx {
        send_data render_to_string, filename: "bulk_import_template_#{Time.zone.now.strftime('%Y%m%d')}.xlsx"
      }
    end
  end

  private
    def shop_products_params
      params.permit(:shop_id,:product_category_id)
    end

    def admin_product_upload_params
      params.fetch(:admin_product_upload, {}).permit(:file)
    end

    def admin_product_collection_params
      params.permit(admin_products: [:id, :product_category_id, :product_no, :name, :item_detail, :brand_name, :variant_name, :tech_spec_name, :brand_id, :variant_id, :tech_spec_id, :default_remind_interval_day, :campaign_code])
    end
end
