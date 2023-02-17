class ShopGroup < ApplicationRecord
  has_many :shops, dependent: :destroy
  accepts_nested_attributes_for :shops
  has_many :subscriptions
  validates :name, length: { maximum: 255 }, presence: true
  validates :owner_name, length: { maximum: 255 }
  validates :owner_tel, length: { maximum: 255 }
  validates :owner_tel2, length: { maximum: 255 }
  validates :owner_email, length: { maximum: 100 }
  validates :founding_year, length: { maximum: 255 }, numericality: true, unless: -> { founding_year.blank? }
  validates :is_chain_shop, inclusion: {in: [true, false]}, unless: -> { is_chain_shop.blank? }
  validates :owner_wa_tel, length: { maximum: 255 }
  validates :virtual_bank_no, length: { maximum: 255 }
  enum owner_gender: { man: 1, woman: 2}
  enum subscriber_type: {
    non_subscriber: 0,
    subscriber: 1,
    paid_subscriber: 2
  }

  before_save :set_shop_group_no

  def self.number_of_registered_accounts(shop_group_id)
    select('users.id').joins(shops: {available_shops: :user}).where("shop_groups.id = ?",shop_group_id).distinct.count
  end

  def has_owner_account?
    has_role_account(:owner)
  end

  def owner
    User.joins(available_shops: :shop).find_by(role: 'owner', shops: {id: self.shop_ids})
  end

  def self.bulk_create(request)
    initial_password = SecureRandom.alphanumeric
    period = 1
    start_date = DateTime.now.beginning_of_day
    expiration_date = Shop.subscription_end_period(start_date, period)

    shop_params = {
      name: request.shop_name,
      address: request.shop_address,
      initial_setup: false,
      expiration_date: expiration_date,
      regency_id: request.regency_id,
      distric_id: request.distric_id
    }

    shop_group_params = {
      name: request.shop_name,
      owner_name: request.name,
      owner_tel: request.tel,
      owner_wa_tel: request.tel,
      owner_email: request.email,
      subscriber_type: ShopGroup.subscriber_types[:subscriber]
    }

    user_params = {
      user_id: request.email,
      uid: request.email,
      name: request.name,
      role: :owner,
      password: initial_password,
      status: 'enabled',
      is_otoraja_biz: request.is_otoraja_biz,
      is_otoraja_bp: request.is_otoraja_bp,
      referral: request.referral
    }
    
    try = 0
    begin
      try += 1
      ActiveRecord::Base.transaction do
        request.status = NewContractRequest.statuses[:processed]
        request.save!
        
        @shop_group = ShopGroup.new(shop_group_params)
        @shop_group.save!
        
        @shop = Shop.new(shop_params)
        @shop.shop_group = @shop_group
        @shop.subscriber_type = Shop.subscriber_types[:subscriber]
        @shop.tel = request.tel
        @shop.save!

        @user = User.new(user_params)
        @user.shops = [@shop]
        @user.save!

        subscription = Subscription.new(
          shop_group: @shop_group,
          plan: 0,
          fee: 0,
          period: 1,
          status: :demo_period,
          shop: @shop,
          start_date: start_date,
          end_date: expiration_date,
          payment_date: Date.today
        )
        subscription.save!
        @shop.update!(active_plan: subscription.id)

        return @user
      end
    rescue ActiveRecord::RecordInvalid => e 
      logger.error(e.message)
      raise
    rescue
      retry if try < 3
      raise
    end
  end

  def self.remove_shop_application(id)
    user = User.find_by(id: id)
    unless user.nil?
      shop_group = ShopGroup.find_by(owner_email: user.user_id).destroy
      unless shop_group.nil?
        shop_group.destroy
      end
      NewContractRequest.destroy_request(user.id)
      user.destroy
    end
  end

  private
    def set_shop_group_no
      if self.group_no.nil?
        self.group_no = format("%0#{6}d", SecureRandom.random_number(10**6))
      end
      self
    end

    def has_role_account(role)
      result = false
      self.shops.each do |shop|
        if shop.has_owner_account?
          result = true
        end
      end
      result
    end
end
