class ProductCategory < ApplicationRecord
  has_many :shop_products
  has_many :admin_products
  belongs_to :product_class
  belongs_to :reminder_body_template, optional: true

  validates :name, presence: true
  validates :campaign_code, presence: true, length: { maximum: 15}, uniqueness: true
  scope :own_shop, ->(shop_ids) {
    joins(:shop_products).where(shop_products: {shop_id: shop_ids}).uniq
  }

  enum brand_validation: {
    required: 'required',
    optional: 'optional',
    unnecessary: 'unnecessary'
  }, _prefix: true

  enum variant_validation: {
    required: 'required',
    optional: 'optional',
    unnecessary: 'unnecessary'
  }, _prefix: true

  enum tech_spec_validation: {
    required: 'required',
    optional: 'optional',
    unnecessary: 'unnecessary'
  }, _prefix: true

end
