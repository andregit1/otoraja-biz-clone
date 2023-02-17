class Api::CustomizeShopProductListsController < Api::ApiController

  def index
    @customize_shop_product_lists = policy_scope(CustomizeShopProductList).all.order(order: :asc)
  end

  def update_list
    order = 1
    params[:customize_shop_product_list].each do |k, n|
      model = policy_scope(CustomizeShopProductList).find(n[:id])
      model.order = order
      model.save!
      order += 1
    end
  end

  def find
    @customize_shop_product_list = policy_scope(CustomizeShopProductList).find(params[:id])
    @customize_shop_product_details = @customize_shop_product_list.customize_shop_product_details.order(order: :asc)
  end

  def create
    shop = current_user.shops.first
    customize_shop_product_lists = policy_scope(CustomizeShopProductList).all.order(order: :asc)
    @customize_shop_product_details = []
    ActiveRecord::Base.transaction do
      @customize_shop_product_list = CustomizeShopProductList.new(
        shop: shop,
        name: params[:name],
        can_add_all: true,
        order: 1
      )
      order_count = 2
      customize_shop_product_lists.each do |n|
        n.order = order_count
        n.save!
        order_count += 1
      end
      @customize_shop_product_list.save!

    end # Transaction End
    render 'find'
  end

  def update
    @customize_shop_product_list = policy_scope(CustomizeShopProductList).find(params[:id])
    ActiveRecord::Base.transaction do
      details = update_params.delete('customize_shop_product_details')
      detail_order = 1
      details.each do |k, n|
        id = n[:id]
        shop_product_id = n[:shop_product_id]
        destroy = n['_destroy']
        detail = if id.present?
          CustomizeShopProductDetail.find(id)
        else
          CustomizeShopProductDetail.new
        end
        if destroy == 'true'
          detail.destroy!
          next
        end
        detail.order = detail_order
        detail_order += 1
        detail.shop_product = ShopProduct.find(shop_product_id)
        if id.present?
          detail.save!
        end
        @customize_shop_product_list.customize_shop_product_details << detail
      end if details.present?
      @customize_shop_product_list.update!(
        name: update_params[:name],
        can_add_all: update_params[:can_add_all],
      )
    end
    @customize_shop_product_details = @customize_shop_product_list.customize_shop_product_details.order(order: :asc)
    render 'find'
  end

  def destroy
    customize_shop_product_list = policy_scope(CustomizeShopProductList).find(params[:id])
    ActiveRecord::Base.transaction do
      customize_shop_product_list.destroy!
    end
  end

private
  def update_list_params
    params.fetch(:customize_shop_product_list, {}).permit(
      [:id]
    )
  end

  def update_params
    params.fetch(:customize_shop_product_list, {}).permit(
      :name,
      :can_add_all,
      customize_shop_product_details: [
        :id,
        :shop_product_id,
        :_destroy
      ]
    )
  end
end
