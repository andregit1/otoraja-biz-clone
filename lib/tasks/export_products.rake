require 'csv'
namespace :export_products do
  top_level = self

  using Module.new {
    refine(top_level.singleton_class) do
      def export_all
        shop_protudts = select_shop_products
        logger.debug {shop_protudts.inspect}
        export_file(shop_protudts, 'otoraja-biz-report', make_file_path('item_master'), 'item_master.csv')
      end

      def export_updated_yesterday
        now = DateTime.now.in_time_zone('Jakarta')
        today = Date.new(now.year, now.month, now.day)
        logger.info {"Execute date #{today} WIB"}
        yesterday = today - 1
        tz_yesterday = DateTime.parse("#{yesterday.year}-#{yesterday.month}-#{yesterday.day} 00:00:00 +0700")
        update_from = tz_yesterday.in_time_zone('UTC')
        update_to = (tz_yesterday.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
        logger.info {"export updated_at from #{update_from} to #{update_to}"}
        shop_protudts = select_shop_products(updated_at_range: Range.new(update_from, update_to))
        logger.debug {shop_protudts.inspect}
        file_name = "updated_item_daily_#{yesterday.strftime('%Y%m%d')}.csv"
        logger.debug {"file name: #{file_name}"}
        export_file(shop_protudts, 'otoraja-biz-report', make_file_path('updated_item'), file_name)
      end

      def select_shop_products(updated_at_range: nil)
        shop_protudts = ShopProduct.eager_load(:shop, product_category: :product_class)
        shop_protudts = shop_protudts.where(updated_at: updated_at_range) if updated_at_range.present?
        shop_protudts.order(:shop_id, :id)
      end

      def export_file(shop_protudts, s3_bucket, file_path, file_name)
        csv_export = CSV.generate(force_quotes: true) do |csv| 
          csv << %w(id shop_id shop_name product_class_name product_category_id product_category_name admin_product_id product_no shop_alias_name item_detail stock_minimum sales_unit_price remind_interval_day is_stock_control is_use created_at updated_at)
          shop_protudts.each do |v|
            column_values = [
              v.id,
              v.shop_id,
              v.shop.name,
              v.product_category.product_class.name,
              v.product_category_id,
              v.product_category.name,
              v.admin_product_id,
              v.product_no,
              v.shop_alias_name,
              v.item_detail,
              v.stock_minimum,
              v.sales_unit_price,
              v.remind_interval_day,
              v.is_stock_control,
              v.is_use,
              v.created_at.strftime('%Y-%m-%d %H:%M:%S'),
              v.updated_at.strftime('%Y-%m-%d %H:%M:%S')
            ]
            csv << column_values
          end
        end
        logger.debug {csv_export}
        if Rails.env.development?
          logger.debug {'save to local storage'}
          File.open(File.join(Rails.root, 'tmp', file_name), 'w') do |file|
            file.write(csv_export)
          end
        else
          key = "#{file_path}/#{file_name}"
          logger.debug {"save to aws s3 bucket: #{s3_bucket} key: #{key}"}
          conf = Aws::AwsUtility.config
          s3 = Aws::AwsUtility.S3_client({
            "region" => 'ap-northeast-1',
            "access_key_id" => conf['access_key_id'],
            "secret_access_key" => conf['secret_access_key']
          })
          s3.put_object(bucket: s3_bucket, key: key, body: csv_export)
        end
      end

      def make_file_path(file_path)
        if Rails.env.production?
          file_path
        elsif Rails.env.staging?
          "staging/#{file_path}"
        else
          "development/#{file_path}"
        end
      end
    end
  }

  desc 'export ShopProducts updated yesterday'
  task updated_yesterday: %i(common) do
    export_updated_yesterday
  end

  desc 'export ShopProducts All'
  task all: %i(common) do
    export_all
  end
end
