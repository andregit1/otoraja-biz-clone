json.maintenance_log_details do
  json.array! @maintenance_log_details do |maintenance_log_detail|
    json.merge! maintenance_log_detail.attributes
    json.set! :shop_product do
      json.merge! maintenance_log_detail.shop_product.attributes
      json.set! :product_category do
        json.merge! maintenance_log_detail.shop_product.product_category.attributes
      end
      json.set! :admin_product do
        json.merge! maintenance_log_detail.shop_product.admin_product.attributes
      end if maintenance_log_detail.shop_product.admin_product.present?
    end if maintenance_log_detail.shop_product.present?
    json.maintenance_mechanics do
      json.array! maintenance_log_detail.maintenance_mechanics do |maintenance_mechanic|
        json.merge! maintenance_mechanic.attributes
        json.set! :shop_staff do
          json.merge! maintenance_mechanic.shop_staff.attributes
        end
      end
    end if maintenance_log_detail.maintenance_mechanics.present?
    json.maintenance_log_detail_related_products do
      json.array! maintenance_log_detail.maintenance_log_detail_related_products do |maintenance_log_detail_related_product|
        json.merge! maintenance_log_detail_related_product.attributes
        json.set! :shop_product do
          json.merge! maintenance_log_detail_related_product.shop_product.attributes
        end
      end
    end if maintenance_log_detail.maintenance_log_detail_related_products.present?
  end
end