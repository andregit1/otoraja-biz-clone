class Api::Admin::ProductNonActiveController < Api::ApiController
  def list
    @shop_products = policy_scope(ShopProduct).where(shop_id: session[:default_user_shop]).discarded
    
    if params[:product_category_id].present?
      @shop_products = @shop_products.where(product_category_id: params[:product_category_id]).discarded
    end

    if params[:search].present?
      search_words = params[:search].split
      search_words.each do |search|
        @shop_products = @shop_products.where('shop_products.shop_alias_name LIKE ? or shop_products.item_detail LIKE ?', "%#{search}%", "%#{search}%").discarded
      end
    end

    order = policy_scope(ShopProduct).sort_condition[params[:sort]&.to_sym] || 'updated_at desc'
    @shop_products = @shop_products.order(order)
    @shop_products = @shop_products.page(params[:page]).per(10)
    @paginator = view_context.paginate(@shop_products)
  end

  def restore_deleted_product
    current_shop_id = session[:default_user_shop]

    if params[:selected_product]
      shop_products = policy_scope(ShopProduct).where(id: params[:selected_product]).discarded
    elsif params[:unselected_product]
      shop_products = policy_scope(ShopProduct).where.not(id: params[:unselected_product]).discarded
    else
      shop_products = policy_scope(ShopProduct).where(shop_id: session[:default_user_shop]).discarded
    end

    shop_products_temps = shop_products
    shop_products_temps.to_json

    if params[:product_category_id].present?
      shop_products = shop_products.where(product_category_id: params[:product_category_id]).discarded
    end

    if params[:search].present?
      search_words = params[:search].split
      search_words.each do |search|
        shop_products = shop_products.where('shop_products.shop_alias_name LIKE ? or shop_products.item_detail LIKE ?', "%#{search}%", "%#{search}%").discarded
      end
    end
    
    begin
      ActiveRecord::Base.transaction do
        shop_products.update_all(deleted_at:nil, is_use: true)
      end
    rescue => e
      logger.error(e.message)
    end
    
    shop_products_temps.each do |product|
      begin
        ShopProduct.es_import_by_id(product.id)
      rescue => e
        logger.error(e)
      end
    end

  end  
end