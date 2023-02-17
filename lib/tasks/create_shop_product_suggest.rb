class CreateShopProductSuggest
  def self.execute
    if ARGV[0] == 'create_index'
      p 'start create_index'
      ShopProduct.create_index!
      p 'end create_index'
    end
    p 'start all data import'
    count = ShopProduct.__elasticsearch__.import
    p "end all data import #{count}"
  end
end

CreateShopProductSuggest.execute
