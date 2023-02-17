class Admin::ShopsController < Admin::ApplicationAdminController
  def index
    shops = if params[:scope] == 'all' && current_user.admin_roles?
      Shop.all
    else
      policy_scope(Shop)
    end
    @shops = shops.where(subscriber_type: [:paid_subscriber, :subscriber]).
      page(params[:page]).per(10).order(id: :asc)
    
  end

  def show
    @shop = if current_user.admin_roles?
      Shop.find(params[:id])
    else
      policy_scope(Shop).find(params[:id])
    end
    @tags = ShopSearchTag.own_shop(@shop.id).is_using()
  end

  #update current selected shop user 
  def default_session_shop
    begin
      shop = policy_scope(Shop).find(shop_params[:shop_id])
      session[:default_user_shop] = shop_params[:shop_id]
      session[:expiration_date] = ApplicationController.helpers.formatedDateUseDash(shop.expiration_date) if shop.expiration_date
      flash[:success] = "Anda berhasil mengganti bengkel ke #{shop.name}"
    rescue => exception
      redirect_to "", flash: {danger: I18n.t('reject_access') }
    end
  end

  private
  def shop_params
    params.permit(:shop_id)
  end
end
