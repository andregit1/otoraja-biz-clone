class Admin::ShopAccountsController < Admin::ApplicationAdminController
  before_action :set_shop_group, only:[:index]
  def index
    @active_subscription = Subscription.active_subscription(@shop_group.id)
    @expired_subscriptions = Subscription.expired_subscriptions(@shop_group.id).page(params[:page]).per(10).order("end_date DESC")
    unless @active_subscription.nil?
      @days_remaining = (Date.parse(@active_subscription.end_date.to_s)-Date.today).to_i 
      @show_notice = @days_remaining <= 7
      flash[:alert] = "Your subscription will expire in #{@days_remaining} days" if @show_notice
    end
  end

  private
  def account_params
    params.fetch(:subscription,{}).permit(:id)
  end
  def set_shop_group
    @shop = current_user.shops
    @shop_group = ShopGroup.find(@shop.first.shop_group_id)
  end
end