namespace :update_shop_product_suggest do
  desc 'update shop product suggest by shop'
  task update_by_shop: %i(common) do
    unless ENV['shop_id'].present?
      logger.error {"Please specify shop_id."}
      logger.info {"usage: rake update_shop_product_suggest:update_by_shop shop_id=12345"}
      next
    end
    shop = Shop.find_by(id: ENV['shop_id'])
    if shop.nil?
      logger.error {"shop was not found shop_id=#{ENV['shop_id']}"}
      next
    end
    logger.info {"start #{shop.name} data import"}
    ShopProduct.es_import(shop.id)
    logger.info {"end all data import"}
  end

  desc 'update shop product suggest all'
  task all: %i(common) do
    if ENV['create_index'] == 'true'
      logger.info {'start create_index'}
      ShopProduct.create_index!
      logger.info {'end create_index'}
    end
    logger.info {'start all data import'}
    count = ShopProduct.__elasticsearch__.import
    logger.info {"end all data import #{count}"}
  end
end
