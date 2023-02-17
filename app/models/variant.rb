class Variant < ApplicationRecord
  has_many :admin_products
  belongs_to :product_category
  validates :name, format: { with: /\A[A-Za-z0-9\-\/\.\,\_\s]+\z/ }

  def duplicateVariantName?(variant_name, product_category_id, variant_id=false)
    variant_name_converted = ApplicationController.helpers.convert_invalid_characters(variant_name)
    
    if variant_id 
      similar_variant_names = Variant.where('name like ? and product_category_id = ? and id != ?', variant_name_converted, product_category_id, variant_id)
    else
      similar_variant_names = Variant.where('name like ? and product_category_id = ?', variant_name_converted, product_category_id)
    end

    if similar_variant_names.present? 
      similar_variant_names.each do |variant|
        errors.add(:name, I18n.t('variant.errors.messages.similar_variant_name', variant_name: variant.name))
      end
    else
      false
    end
  end
  
end