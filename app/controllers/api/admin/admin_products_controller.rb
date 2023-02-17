class Api::Admin::AdminProductsController < Api::ApiController
    def list
      shop_products_sql = ShopProduct.where(shop_id: params[:shop_id]).distinct.to_sql
      @products = AdminProduct.select("admin_products.*, sp.id as shop_product_id").joins("LEFT JOIN (" + shop_products_sql + ") AS sp ON admin_products.id = sp.admin_product_id ").order(id: :desc)
      if params[:product_category_id].present?
        @products = @products.where(product_category_id: params[:product_category_id])
      end
  
      if params[:search].present?
        search_words = params[:search].split
        search_words.each do |search|
          @products = @products.where('admin_products.name LIKE ?', "%#{search}%")
        end
      end
    end
  
    def product_categories
      @product_categories = ProductCategory.joins(:admin_products).distinct
    end

    def brands
      @brands = Brand.joins(:admin_products).distinct
    end

    def variants
      @variants = Variant.joins(:admin_products).distinct
    end

    def tech_specs
      @tech_specs = TechSpec.joins(:admin_products).distinct
    end
  
    def import
      shop_id = params[:shop_id]
      import_product_ids = params[:import_product_ids]
      import_products = []
      products = AdminProduct.where(id: import_product_ids)
      products.each do |product|
        next if ShopProduct.find_by(admin_product_id: product.id, shop_id: shop_id).present?
        import_products << ShopProduct.new(
          shop_id: shop_id,
          product_category_id: product.product_category_id,
          admin_product_id: product.id,
          product_no: product.product_no,
          shop_alias_name: product.name,
          item_detail: product.item_detail,
          remind_interval_day: product.default_remind_interval_day,
          is_stock_control: false,
          is_use: true
        )
      end
      
      begin

        ShopProduct.import import_products
  
        # 全文検索更新
        ShopProduct.es_import(
          shop_id
        )
  
        @msg = 'success'
      rescue => e
        @msg = e.message
      end
    end
  end
  