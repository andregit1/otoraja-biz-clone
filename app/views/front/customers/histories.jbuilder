json.customer do
  json.merge! @customer.attributes
end if @customer.present?
json.maintenance_logs do
  json.array! @histories do |maintenance_log|
    json.merge! maintenance_log.attributes
    json.set! :checkin do
      json.checkin_no maintenance_log.checkin.checkin_no
      json.merge! maintenance_log.checkin.attributes
      json.set! :customer do
        json.merge! maintenance_log.checkin.customer.attributes
      end if maintenance_log.checkin.customer.present?
    end if maintenance_log.checkin.present?
    json.maintenance_log_details do
      json.array! maintenance_log.maintenance_log_details do |maintenance_log_detail|
        json.merge! maintenance_log_detail.attributes
        json.set! :shop_product do
          json.merge! maintenance_log_detail.shop_product.attributes
          json.set! :product_category do
            json.merge! maintenance_log_detail.shop_product.product_category.attributes
          end
          json.set! :stock do
            json.merge! maintenance_log_detail.shop_product.stock.attributes
          end if maintenance_log_detail.shop_product.stock.present?
        end if maintenance_log_detail.shop_product.present?
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
  end
end
