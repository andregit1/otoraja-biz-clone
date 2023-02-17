json.merge! shop_product.attributes
json.set! :stock do
  json.merge! shop_product.stock.attributes
end if shop_product.stock.present?
json.set! :product_category do
  json.merge! shop_product.product_category.attributes
end if shop_product.product_category.present?
json.set! :admin_product do
  json.merge! shop_product.admin_product.attributes
end if shop_product.admin_product.present?
json.packaging_product_relations do
  json.array! shop_product.packaging_product_relations_packaging do |packaging_product|
    json.merge! packaging_product.attributes
    json.set! :inclusion_product do
      json.merge! packaging_product.inclusion_product.attributes
      json.set! :stock do
        json.merge! packaging_product.inclusion_product.stock.attributes
      end if packaging_product.inclusion_product.stock.present?
      json.set! :product_category do
        json.merge! packaging_product.inclusion_product.product_category.attributes
      end if packaging_product.inclusion_product.product_category.present?
      json.set! :admin_product do
        json.merge! packaging_product.inclusion_product.admin_product.attributes
      end if packaging_product.inclusion_product.admin_product.present?
    end
  end
end if shop_product.has_inclusion_product?
