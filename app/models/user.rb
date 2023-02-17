class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:user_id]
  devise :two_factor_authenticatable, :otp_secret_encryption_key => ENV['TWO_FACTOR_ENCRYPTION_KEY']
  devise :database_authenticatable
  include DeviseTokenAuth::Concerns::User

  has_many :available_shops
  has_many :shops, through: :available_shops
  accepts_nested_attributes_for :available_shops, reject_if: :all_blank, allow_destroy: true

  belongs_to :export_pattern, optional: true

  enum roles:[:admin, :admin_operator, :owner, :shop_manager, :manager, :staff]

  # user_idを必須、一意とする
  validates_uniqueness_of :user_id
  validates_presence_of :user_id
  validates :password, presence: true, on: :create
  validates :name, presence: true
  validates :role, inclusion: {in: User.roles.keys}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: -> {email.blank?}
  validates :password, :password_confirmation, confirmation: true

  scope :own_shop, ->(shop_ids) {
    joins(:shops).where(shops: { id: shop_ids } )
  }

  scope :enabled, -> { where(status: 'enabled') }

  # user_id or emailで認証できるように条件を変更
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:user_id)
      where(conditions).where(["user_id = :value", { :value => login.downcase }]).first
    else
      if conditions[:user_id].nil?
        where(conditions).first
      else
        where(user_id: conditions[:user_id]).first
      end
    end
  end

  def validate_user_id
    if User.where(email: user_id).exists?
      errors.add(:user_id, :invalid)
    end
  end

  def shop_group_no
    shops.first&.shop_group&.group_no
  end

  #カレントパスワード無しでパスワードを更新する
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    clean_up_passwords
    update_attributes(params, *options)
  end

  def self.search_by_userid_or_email(param)
    where(["user_id = :value OR email = :value", { :value => param&.downcase }]).first
  end

  def self.find_users_by_shopgroup(group_id)
    User.joins(shops: :shop_group).where("shop_groups.id = ?",group_id).where.not(users: {role: ['admin','admin_operator']})
  end

  def self.generate_employee_user_id(user_id,shop_group_no)
    sprintf('%s@%s',user_id,shop_group_no)
  end


  # TODO 画面からの入力の場合のみパスワードを必須にする
  # def password_required?
  #   true
  # end

  # 登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def admin?
    self.role === 'admin'
  end

  def admin_operator?
    self.role === 'admin_operator'
  end

  def admin_roles?
    self.admin? || self.admin_operator?
  end

  def shop_admin_roles?
    self.manager? || self.shop_manager? || self.owner?
  end

  def is_available_front?
    self.staff? || self.manager? || self.shop_manager? || self.owner?
  end

  def staff?
    self.role === 'staff'
  end

  def manager?
    self.role === 'manager'
  end

  def shop_manager?
    self.role === 'shop_manager'
  end

  def owner?
    self.role === 'owner'
  end

  def will_save_change_to_email?
    false
  end

  def active_for_authentication?
    super && is_enabled? && is_subscriber?
  end

  def inactive_message
    is_enabled? ? super : :inactive
  end

  def is_enabled?
    self.status == 'enabled'
  end

  def is_subscriber?
    return true if self.admin_roles?
    return false if self.shops.first.shop_group.nil?
    return true if self.owner?
    return self.shops.find{|m| m.subscriber? || m.paid_subscriber? || m.is_reactivated.present? }.present?
  end

  def is_first_login?
    self.sign_in_count == 1 && self.created_at == self.updated_at
  end

  def managed_shops
    if self.admin_roles?
      Shop.own_shop(AvailableShop.group(:shop_id).pluck(:shop_id))
    else
      self.shops
    end
  end

  def managed_shops_without_suspended
    if self.admin_roles?
      Shop.own_shop(AvailableShop.group(:shop_id).pluck(:shop_id))
    elsif self.manager? || self.shop_manager?
      self.shops.where("shops.subscriber_type != ? OR shops.is_reactivated = ?", 0, true)
    else
      self.shops
    end
  end

  def managed_shops_front_apps
      self.shops
        .where("shops.subscriber_type != ? OR shops.is_reactivated = ?", 0, true)
        .select("shops.id as shop_id", "bengkel_id", "name as shop_name", "CASE WHEN shops.subscriber_type=0 THEN FALSE ELSE TRUE END AS subscriber_status")
  end

  def export_columns(export_type)
    self.export_pattern.export_layouts.find_by(export_type: export_type).export_layout_columns.order(:order)
  end
end
