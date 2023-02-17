class ShopsImport
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
        key: "shops_import/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    data = JSON.parse(obj.body.read)
    data.each do |row|
      puts "#{row.inspect}"
      if row['id'].nil? && row['bengkel_id'].nil?
        puts "has not id or bengkel_id"
        puts "#{row.inspect}"
        next
      end

      shop = if row['id'].present?
        Shop.find_or_initialize_by(row['id'])
      else
        Shop.find_or_initialize_by(bengkel_id: row['bengkel_id'])
      end

      if shop.nil?
        puts "shop is nil"
        puts "#{row.inspect}"
        next
      end

      if shop.new_record? && shop.bengkel_id.blank?
        shop.bengkel_id = (row['id'].to_i * 100000).to_s
      end

      shop.name ||= row['name']
      shop.tel ||= row['tel']
      shop.address ||= row['address']
      shop.longitude ||= row['longitude']
      shop.latitude ||= row['latitude']
      if row['region_id'].present?
        shop.region_id = row['region_id']
      else
        shop.region ||= Region.find_by(name: row['region'])
      end
      if row['province_id'].present?
        shop.province_id = row['province_id']
      else
        shop.province ||= Province.find_by(name: row['province'])
      end
      shop.regency_id ||= row['regency_id']

      begin
        shop.save!
        puts "#{shop.inspect}"
      rescue => e
        puts "#{shop.inspect}"
        puts "Shop Save Error !!: #{e}"
        puts e.backtrace.join("\n")
        next
      end

      # Shop Business Hours
      row['shop_business_hours'].each do |shop_business_hour|
        next if shop_business_hour['day_of_week'].nil?

        sbh = ShopBusinessHour.find_or_initialize_by(
          shop: shop,
          day_of_week: shop_business_hour['day_of_week']
          )

        sbh.is_holiday = shop_business_hour['is_holiday']
        if sbh.is_holiday
          sbh.open_time_hour = nil
          sbh.open_time_minute = nil
          sbh.close_time_hour = nil
          sbh.close_time_minute = nil
        else
          sbh.open_time_hour = shop_business_hour['open_time_hour']
          sbh.open_time_minute = shop_business_hour['open_time_minute']
          sbh.close_time_hour = shop_business_hour['close_time_hour']
          sbh.close_time_minute = shop_business_hour['close_time_minute']
        end

        begin
          sbh.save!
          puts "#{sbh.inspect}"
        rescue => e
          puts "#{sbh.inspect}"
          puts "ShopBusinessHour Save Error !!: #{e}"
          puts e.backtrace.join("\n")
          next
        end
      end

      #Shop Config
      ShopConfig.create(
        shop: shop,
        front_priority_display: 'number_plate',
        use_customer_remind: false,
        use_receipt: false,
        receipt_layout: 'A4_portrait',
        receipt_open_expiration_days: 30,
        close_stock_time: Time.local(2019, 1, 1, 14),
        use_record_stock: false,
        use_stock_notification: false,
      ) if ShopConfig.find_by(shop:shop).nil?

    end
  end
end
I18n.default_locale = :en
ShopsImport.execute
