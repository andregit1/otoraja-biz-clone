class SnsCostStartQuery
  def self.execute
    puts 'Execute sns_cost_start_query.rb'

    # 送信済みかつ送信ステータス&送信コスト未取得 (１番古いSMS送信日時を取得のため昇順並び替え)
    need_query_send_messages = SendMessage.where(send_status: nil, send_cost: nil, send_type: :sms).where.not(message_id: nil, sent_at: nil).order(:sent_at)

    unless need_query_send_messages.empty?
      save_count = 0
      client = Aws::AwsUtility.CloudWatchLogs_client

      # ロググループ名用にAWSアカウントID取得
      sts = Aws::AwsUtility.STS_client
      sts_resp = sts.get_caller_identity({})
      sms_log_group_name = "sns/#{ENV['AWS_DEFAULT_REGION']}/#{sts_resp.account}/DirectPublishToPhoneNumber"
      failure_sms_log_group_name = "sns/#{ENV['AWS_DEFAULT_REGION']}/#{sts_resp.account}/DirectPublishToPhoneNumber/Failure"

      # query_string生成
      message_id_filter =  need_query_send_messages.map {|send_message| "notification.messageId = '#{send_message.message_id}'"}.join(' or ')
      filter = "filter #{message_id_filter}"
      query_string = "fields status, notification.messageId, delivery.priceInUSD | #{filter}"

      # １番古いSMS送信日時から現在までを検索
      start_time = need_query_send_messages.first.sent_at.to_time.to_i
      end_time = Time.now.to_i
    
      start_query_resp = client.start_query({
        log_group_names: [sms_log_group_name, failure_sms_log_group_name],
        start_time: start_time,
        end_time: end_time,
        query_string: query_string,
      })

      need_query_send_messages.update_all(query_id: start_query_resp.query_id)

      puts "Result: Save Query ID"
    else
      puts 'Result: There was no query'
    end
  end

end

SnsCostStartQuery.execute
