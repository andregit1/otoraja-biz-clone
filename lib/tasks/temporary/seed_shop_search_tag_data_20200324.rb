class SeedShopSearchTagData20200324
  def self.execute
    Shop.all.each do |shop|
      tags = []
      SearchTag.all.each_with_index do |search_tag, index |
      index += 1
      tags << {shop_id: shop.id, name: search_tag.tag, order: index, is_using: true}
      end
      ShopSearchTag.create(tags)
    end
  end
end

SeedShopSearchTagData20200324.execute