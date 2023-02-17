class AdminProduct < ApplicationRecord
  belongs_to :product_category
  has_many :shop_products
  has_many :admin_product_designated_motorcycles, dependent: :destroy
  has_many :designated_motorcycles, through: :admin_product_designated_motorcycles, source: :bike_model

  accepts_nested_attributes_for :admin_product_designated_motorcycles, reject_if: :all_blank, allow_destroy: true

  belongs_to :brand, optional: true
  belongs_to :variant, optional: true
  belongs_to :tech_spec, optional: true

  validates :brand, presence: true, if: -> {self.product_category.brand_validation_required?}
  validates :brand, absence: true, if: -> {self.product_category.brand_validation_unnecessary?}
  validates :variant, presence: true, if: -> {self.product_category.variant_validation_required?}
  validates :variant, absence: true, if: -> {self.product_category.variant_validation_unnecessary?}
  validates :tech_spec, presence: true, if: -> {self.product_category.tech_spec_validation_required?}
  validates :tech_spec, absence: true, if: -> {self.product_category.tech_spec_validation_unnecessary?}
end
