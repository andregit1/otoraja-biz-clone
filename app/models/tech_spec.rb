class TechSpec < ApplicationRecord
  has_many :admin_products
  belongs_to :product_category

  validates :name, format: { with: /\A[A-Za-z0-9\-\/\.\,\_\s]+\z/ }

  def duplicateTechSpecName?(tech_spec_name, product_category_id, tech_spec_id=false)
    tech_spec_name_converted = ApplicationController.helpers.convert_invalid_characters(tech_spec_name)
    if tech_spec_id 
      similar_tech_spec_names = TechSpec.where('name like ? and product_category_id = ? and id != ?', tech_spec_name_converted, product_category_id, tech_spec_id)
    else
      similar_tech_spec_names = TechSpec.where('name like ? and product_category_id = ?', tech_spec_name_converted, product_category_id)
    end

    if similar_tech_spec_names.present? 
      similar_tech_spec_names.each do |tech_spec|
        errors.add(:name, I18n.t('tech_spec.errors.messages.similar_tech_spec_name', tech_spec_name: tech_spec.name))
      end
    else
      false
    end
  end
end
