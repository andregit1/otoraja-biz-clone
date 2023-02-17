class ShopProductsImport
  def self.execute
    unless ARGV.length == 1
      puts "ex:#{File.basename(__FILE__)} import_data.json"
      return
    end

    # AWS Setting
    conf = Aws::AwsUtility.config
    s3 = Aws::AwsUtility.S3_client({
      "region" => 'ap-northeast-1',
      "access_key_id" => conf['access_key_id'],
      "secret_access_key" => conf['secret_access_key']
    })
    begin
      obj = s3.get_object({
        bucket: 'otoraja-biz-datastore',
        key: "product_import/shop_products/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    data = JSON.parse(obj.body.read)
    data.each do |row|

      # カテゴリー名を検索する
      product_category = ProductCategory.find_by(name: row['product_category_name'])
      if product_category.nil?
        # カテゴリーが存在しない場合、登録しない
        puts "ProductCategory NotFound !!: #{row['product_category_name']}"
        next
      end

      shop_product = if row['id'].present?
        ShopProduct.find(row['id'])
      else
        # 店舗商品をshop_alias_name,item_detailで検索
        ShopProduct.find_or_initialize_by(
          shop_id: row['shop_id'],
          shop_alias_name: row['shop_alias_name'],
          item_detail: row['item_detail'],
          product_category: product_category
          )
      end

      # TODO 運営用商品マスタとの紐付け

      shop_product.shop_id = row['shop_id']
      shop_product.shop_alias_name = row['shop_alias_name']
      shop_product.item_detail = row['item_detail']
      shop_product.product_category = product_category
      shop_product.sales_unit_price = value_of_nil(row['sales_unit_price'])&.to_i
      shop_product.is_use = row['is_use'] || true
      if shop_product.new_record?
        shop_product.stock_minimum = value_of_nil(row['stock_minimum'])&.to_i
        shop_product.remind_interval_day = value_of_nil(row['remind_interval_day'])&.to_i
        shop_product.is_stock_control = row['is_stock_control'] || false
      end

      begin
        shop_product.save!
        puts "#{shop_product.inspect}"
      rescue => e
        puts "#{shop_product.inspect}"
        puts "ShopProduct Save Error !!: #{e}"
        puts e.backtrace.join("\n")
      end
    end
  end

  private
  def self.value_of_nil(value)
    return nil if value.nil? || value.to_s.upcase === 'NULL'
    value
  end
end

ShopProductsImport.execute
