class AdminProductsImport
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
        key: "product_import/admin_products/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    data = JSON.parse(obj.body.read)
    data.each do |row|
      admin_product = if row['id'].present?
        AdminProduct.find(row['id'])
      else
        # 運営商品をname,item_detailで検索
        AdminProduct.find_or_initialize_by(
          name: row['name'],
          item_detail: row['item_detail']
          )
      end

      # カテゴリー名を検索する
      product_category = ProductCategory.find_by(name: row['product_category_name'])
      if product_category.nil?
        # カテゴリーが存在しない場合、登録しない
        puts "ProductCategory NotFound !!: #{row['product_category_name']}"
        next
      end

      admin_product.name = row['name']
      admin_product.item_detail = row['item_detail']
      admin_product.product_category = product_category
      admin_product.default_remind_interval_day = value_of_nil(row['default_remind_interval_day'])&.to_i
      admin_product.campaign_code = value_of_nil(row['campaign_code'])&.to_s

      begin
        admin_product.save!
      rescue => e
        puts "#{admin_product.inspect}"
        puts "AdminProduct Save Error !!: #{e}"
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

AdminProductsImport.execute
