require 'csv'
namespace :export_sales do
  top_level = self

  using Module.new {
    refine(top_level.singleton_class) do
      def export_checkin_yesterday
        now = DateTime.now.in_time_zone('Jakarta')
        today = Date.new(now.year, now.month, now.day)
        logger.info {"Execute date #{today} WIB"}
        yesterday = today - 1
        tz_yesterday = DateTime.parse("#{yesterday.year}-#{yesterday.month}-#{yesterday.day} 00:00:00 +0700")
        start_date = tz_yesterday.in_time_zone('UTC')
        end_date = (tz_yesterday.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
        logger.info {"export checkin_datetime from #{start_date} to #{end_date}"}
        sales_data = select_sales_data(checkin_date_range: Range.new(start_date, end_date))
        logger.debug {sales_data.inspect}
        file_name = "sales_data_daily_#{yesterday.strftime('%Y%m%d')}.csv"
        logger.debug {"file name: #{file_name}"}
        export_file(sales_data, 'otoraja-biz-report', make_file_path('sales_data'), file_name)
      end

      def select_sales_data(checkin_date_range: nil)
        sales_data = MaintenanceLogDetail.eager_load(maintenance_log:{checkin: :shop})
        sales_data = sales_data.where(checkins: {datetime: checkin_date_range}) if checkin_date_range.present?
        sales_data.order(:id)
      end

      def export_file(sales_data, s3_bucket, file_path, file_name)
        csv_export = CSV.generate(force_quotes: true) do |csv|
          csv << %w(checkin_id checkin_datetime checkout_datetime shop_name number_plate_area number_plate_number number_plate_pref expiration_month expiration_year product_no product_name product_description quantity unit_price sub_total_price gross_profit discount_type discount_rate discount_amount)
          sales_data.each do |v|
            column_values = [
              v.maintenance_log.checkin.id,
              v.maintenance_log.checkin.datetime.in_time_zone('Jakarta').strftime('%d-%b-%Y %H:%M:%S'),
              v.maintenance_log.checkin.checkout_datetime.present? ? v.maintenance_log.checkin.checkout_datetime.in_time_zone('Jakarta').strftime('%d-%b-%Y %H:%M:%S') : "",
              v.maintenance_log.checkin.shop.name,
              v.maintenance_log.number_plate_area,
              v.maintenance_log.number_plate_number,
              v.maintenance_log.number_plate_pref,
              v.maintenance_log.expiration_month,
              v.maintenance_log.expiration_year,
              v.product_no,
              v.name,
              v.description,
              v.quantity,
              v.unit_price,
              v.sub_total_price,
              v.gross_profit,
              v.discount_type,
              v.discount_rate,
              v.discount_amount
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

  desc 'export Checkin yesterday'
  task checkin_yesterday: %i(common) do
    export_checkin_yesterday
  end
end
