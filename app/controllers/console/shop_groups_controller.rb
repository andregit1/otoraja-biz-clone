class Console::ShopGroupsController < Console::ApplicationConsoleController
  before_action :set_shop_group, only: [:show, :edit, :update, :destroy]
  before_action :set_selectable_shops, only: [:new, :create, :edit, :update]

  def index
    if params[:start_date_shop_groups].present?
      @shop_groups = ShopGroup.
        where(created_at: params[:start_date_shop_groups]..params[:end_date_shop_groups])
    else
      @shop_groups = ShopGroup.all
    end

    @q = @shop_groups.order(id: :desc).ransack(params[:q])
    @shop_groups = @q.result.page(params[:page]).per(10)
  end

  def show
    @users = User.find_users_by_shopgroup(params[:id])
  end

  def new
    @user = User.new
    @shop_group = ShopGroup.new
  end

  def edit
  end

  def create
    @shop_group = ShopGroup.new(shop_group_params)
    @shop_group.subscriber!

    if @shop_group.save!
      redirect_to console_shop_groups_path, flash: {success: 'Group was successfully created.'}
    else
      render :new
    end
  end

  def update
    @shop_group.assign_attributes(shop_group_params)
    owner = @shop_group.owner
    shop_ids = shop_group_params[:shop_ids].compact.reject(&:empty?)
    begin
      ActiveRecord::Base.transaction do
        @shop_group.save!
        unless owner.nil?
          shop_ids.each do |shop_id|
            owner.shops << Shop.find_by(id: shop_id) if AvailableShop.find_by(user_id: owner.id, shop_id: shop_id).nil?
          end
        end

        redirect_to console_shop_group_path(@shop_group), flash: {success: 'Group was successfully updated.'}
      end
    rescue => e
      render :edit
    end
  end

  private
    def set_shop_group
      @shop_group = ShopGroup.find(params[:id])
    end

    def set_selectable_shops
      @selectable_shops = Shop.where(shop_group_id: nil)
      unless @shop_group.nil?
        @selectable_shops = @selectable_shops.or(Shop.where("shop_group_id = ?", @shop_group.id))
      end
    end

    def shop_group_params
      params.fetch(:shop_group, {}).permit(
        :name,
        :founding_year,
        :is_chain_shop,
        :owner_name,
        :owner_gender,
        :owner_tel,
        :owner_tel2,
        :owner_email,
        :subscriber_type,
        :virtual_bank_no,
        :owner_wa_tel,
        {
          :shop_ids => []
        }
      )
    end
end
