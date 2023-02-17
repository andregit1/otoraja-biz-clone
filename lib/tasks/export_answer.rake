require 'csv'
namespace :export_answer do
  top_level = self

  using Module.new {
    refine(top_level.singleton_class) do
      def export_answer_yesterday
        now = DateTime.now.in_time_zone('Jakarta')
        today = Date.new(now.year, now.month, now.day)
        logger.info {"Execute date #{today} WIB"}
        yesterday = today - 1
        tz_yesterday = DateTime.parse("#{yesterday.year}-#{yesterday.month}-#{yesterday.day} 00:00:00 +0700")
        start_date = tz_yesterday.in_time_zone('UTC')
        end_date = (tz_yesterday.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
        logger.info {"export answered_at from #{start_date} to #{end_date}"}
        answer_data = select_answer_data(answered_at_range: Range.new(start_date, end_date))
        logger.debug {answer_data.inspect}
        file_name = "answers_daily_#{yesterday.strftime('%Y%m%d')}.csv"
        logger.debug {"file name: #{file_name}"}
        export_file(answer_data, 'otoraja-biz-report', make_file_path('answer_data'), file_name)
      end

      def select_answer_data(answered_at_range: nil)
        answer_data = Answer.eager_load(questionnaire:{checkin: :shop})
        answer_data = answer_data.where(answered_at: answered_at_range) if answered_at_range.present?
        answer_data.order(:answered_at)
      end

      def export_file(answer_data, s3_bucket, file_path, file_name)
        csv_export = Answer.generate_csv(answer_data)
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
          s3.put_object(
            bucket: s3_bucket,
            key: key,
            body: csv_export,
            content_type: 'text/csv'
          )
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

  desc 'export Answer yesterday'
  task answer_yesterday: %i(common) do
    export_answer_yesterday
  end
end
