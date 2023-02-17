json.set! :shop do
  json.merge! @shop.attributes
  json.logo_url @shop&.shop_logo.attached? ? full_url_for(@shop.shop_logo) : ''
  json.set! :shop_config do
    json.merge! @shop.shop_config.attributes
  end
  json.payment_methods do
    json.array! @shop.payment_methods do |payment_method|
      json.merge! payment_method.attributes
    end
  end
  json.shop_staffs do
    json.array! @shop.shop_staffs do |shop_staff|
      json.merge! shop_staff.attributes
    end
  end
end
