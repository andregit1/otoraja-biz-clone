class Admin::ProductCategoriesController < Admin::ApplicationAdminController

  def index
    @q = ProductCategory.ransack(params[:q])
    @product_categories = @q.result.order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.reminder_body_template = ReminderBodyTemplate.find_by(title: 'product reminder') if @product_category.product_class.name === 'PARTS'

    if @product_category.save
      redirect_to admin_product_categories_path, notice: 'Product category was successfully created.' 
    else
      render :new
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end
  
  def update
    @product_category = ProductCategory.find(params[:id])
    @product_category.assign_attributes(product_category_params)
    @product_category.reminder_body_template = ReminderBodyTemplate.find_by(title: 'product reminder') if @product_category.product_class.name === 'PARTS'
    
    if @product_category.save
      redirect_to admin_product_categories_path, notice: 'Product category was successfully updated.'
    else
      render :edit
    end
  end

  private
    def product_category_params
      params.fetch(:product_category, {}).permit(
        :name, :campaign_code, :product_class_id, :use_reminder, :remind_grouping
      )
    end
end
