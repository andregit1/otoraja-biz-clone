json.set! :customize_shop_product_list do
  json.merge! @customize_shop_product_list.attributes
  json.customize_shop_product_details do
    json.array! @customize_shop_product_details do |detail|
      json.merge! detail.attributes
      json.set! :shop_product do
        json.merge! detail.shop_product.attributes
        json.product_name(detail.shop_product.product_name)
        json.inclusion_products do
          json.array! detail.shop_product.packaging_product_relations_packaging do |inclusion_product|
            json.id(inclusion_product.inclusion_product.id)
            json.product_no(inclusion_product.inclusion_product.product_no)
            json.product_name(inclusion_product.inclusion_product.product_name)
            json.item_name(inclusion_product.inclusion_product.shop_alias_name)
            json.category_name(inclusion_product.inclusion_product.product_category.name)
            json.item_detail(inclusion_product.inclusion_product.item_detail)
            json.quantity(inclusion_product.quantity)
            json.stock(inclusion_product.inclusion_product&.stock_quantity || '--')
          end
        end if detail.shop_product.has_inclusion_product?
      end
    end
  end
end
