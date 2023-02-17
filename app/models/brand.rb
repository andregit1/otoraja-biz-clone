class Brand < ApplicationRecord
  has_many :admin_products

  validates :name, format: { with: /\A[A-Za-z0-9\-\/\.\,\_\s]+\z/ }

  def duplicateBrandName?(brand_name, brand_id=false)
    brand_name_converted = ApplicationController.helpers.convert_invalid_characters(brand_name)
    if brand_id 
      similar_brand_names = Brand.where('name like ? and id != ?', brand_name_converted, brand_id)
    else
      similar_brand_names = Brand.where('name like ?', brand_name_converted)
    end

    if similar_brand_names.present? 
      similar_brand_names.each do |brand|
        errors.add(:name, I18n.t('brand.errors.messages.similar_brand_name', brand_name: brand.name))
      end
    else
      false
    end
  end

end
