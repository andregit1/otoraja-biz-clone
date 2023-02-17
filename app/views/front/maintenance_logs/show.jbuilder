json.set! :maintenance_log do
  json.merge! @maintenance_log.attributes
  json.down_payment_amount @maintenance_log.total_down_payment_amount
  json.total_price !@maintenance_log.total_price.nil? ? @maintenance_log.total_price : 0
  json.set! :checkin do
    json.checkin_no @maintenance_log.checkin.checkin_no
    json.merge! @maintenance_log.checkin.attributes
    json.checkout_datetime @maintenance_log.checkin.is_checkout ? @maintenance_log.checkin.checkout_datetime : nil
    json.set! :customer do
      json.merge! @maintenance_log.checkin.customer.attributes
      json.is_pending_verify_tel (@maintenance_log.checkin.customer.tmp_tel ? true : false)
      json.owned_bikes do
        json.array! @maintenance_log.checkin.customer.owned_bikes do |owned_bike|
          json.merge! owned_bike.attributes
          json.set! :bike do
            json.merge! owned_bike.bike.attributes
          end if owned_bike.bike.present?
        end
      end if @maintenance_log.checkin.customer.owned_bikes.present?
    end if @maintenance_log.checkin.customer.present?
  end if @maintenance_log.checkin.present?
  json.set! :maintenanced_staff do
    json.merge! @maintenance_log.maintained_staff.attributes
  end if @maintenance_log.maintained_staff.present?
  json.maintenance_log_details do
    json.array! @maintenance_log.maintenance_log_details do |maintenance_log_detail|
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
  # TODO PaymentMethods
end
