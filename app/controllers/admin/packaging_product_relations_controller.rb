class Admin::PackagingProductRelationsController < Admin::ApplicationAdminController
  before_action :get_product_categories, only:[:index, :new, :create, :edit, :update]
  before_action :get_shop, only:[:index, :new, :create, :edit, :update]
  before_action :get_includable_products, only:[:new, :create, :edit, :update]

  def index
    @selected_shop = params.fetch(:q, {})[:packaging_product_shop_id_eq] || @shops.where(id: session[:default_user_shop]).first
    @selected_category = params.fetch(:q, {})[:packaging_product_product_category_id_eq]
    @q = policy_scope(PackagingProductRelation).joins(:packaging_product).where('shop_products.shop_id': session[:default_user_shop]).select('shop_products.*, packaging_product_relations.packaging_product_id').distinct.ransack(params[:q])
    @packaging_products = @q.result.order('shop_products.id asc').page(params[:page]).per(10)
  end

  def new
    @shop_product = ShopProduct.new
    @shop_product.is_use = true
  end

  def create
    @shop_product = ShopProduct.new(shop_product_params)
    @shop_product.is_stock_control = false
    if @shop_product.save
      ShopProduct.es_import_by_id(@shop_product.id)
      redirect_to admin_packaging_product_relations_path, notice: 'Packaging Product was successfully created.' 
    else
      render :new
    end
  end

  def edit
    begin
      @shop_product = policy_scope(ShopProduct).find(params[:id])
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  def update
    begin
      @shop_product = policy_scope(ShopProduct).find(params[:id])
      @shop_product.assign_attributes(shop_product_params)
      if @shop_product.save
        ShopProduct.es_import_by_id(@shop_product.id)
        redirect_to admin_packaging_product_relations_path, notice: 'Packaging Product was successfully updated.'
      else
        render :edit
      end
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

private
  def shop_product_params
    params.fetch(:shop_product, {}).permit(
      :shop_id,
      :product_category_id,
      :shop_alias_name,
      :item_detail,
      :sales_unit_price,
      :is_use,
      packaging_product_relations_packaging_attributes:[
        :id,
        :inclusion_product_id,
        :quantity,
        :_destroy,
      ]
    )
  end

  def get_shop
    @shops = current_user.managed_shops.where(id: session[:default_user_shop])
  end

  def get_product_categories
    @product_categories = ProductCategory.joins(:product_class).where(product_classes: {can_includable: false}).order(id: :asc)
  end

  def get_includable_products
    @includable_products = policy_scope(ShopProduct).where(shop_id: session[:default_user_shop]).joins(product_category: :product_class).where(product_categories:{product_classes:{can_includable:true}}).order(id: :asc)
  end
end
