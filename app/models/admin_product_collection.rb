class AdminProductCollection
  include ActiveModel::Model
  attr_accessor :admin_products

  def initialize(attributes = {})
    if attributes.present?
      self.admin_products = attributes.map do |attribute|
        accepted_attribute = attribute.except(:brand_name, :variant_name, :tech_spec_name)
        if accepted_attribute[:id].present?
          admin_product = AdminProduct.find_by(id: accepted_attribute[:id])
          admin_product.assign_attributes(accepted_attribute)
          admin_product
        else
          AdminProduct.new(accepted_attribute)
        end
      end
    end
  end

  def save(additional_admin_product_params)
    is_success = true
    ActiveRecord::Base.transaction do
      admin_products.each_with_index do |admin_product, index|
        if admin_product.brand.nil? && additional_admin_product_params[index][:brand_name].present?
          admin_product.build_brand(name: additional_admin_product_params[index][:brand_name])
        end

        if admin_product.variant.nil? && additional_admin_product_params[index][:variant_name].present?
          admin_product.build_variant(name: additional_admin_product_params[index][:variant_name], product_category_id: admin_product.product_category.id)
        end

        if admin_product.tech_spec.nil? && additional_admin_product_params[index][:tech_spec_name].present?
          admin_product.build_tech_spec(name: additional_admin_product_params[index][:tech_spec_name], product_category_id: admin_product.product_category.id)
        end

        admin_product.save!
      end
    end
    rescue => e
      Rails.logger.error(e)
      is_success = false
    ensure
      return is_success
  end

end