class ProductCategoriesImport
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
        key: "product_import/product_categories/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    data = JSON.parse(obj.body.read)
    data.each do |row|
      product_category = if row['id'].present?
        ProductCategory.find(row['id'])
      else
        ProductCategory.find_or_initialize_by(name: row['name'])
      end

      product_category.product_class_id = row['product_class_id']
      product_category.reminder_body_template_id = row['reminder_body_template_id']
      product_category.name = row['name']
      product_category.use_reminder = row['use_reminder']
      product_category.remind_grouping = row['remind_grouping']
      product_category.campaign_code = row['campaign_code']

      begin
        product_category.save!
      rescue => e
        puts "#{row}"
        puts "#{product_category.inspect}"
        puts "ProductCategory Save Error !!: #{e}"
        puts e.backtrace.join("\n")
      end
    end
  end

end

ProductCategoriesImport.execute
