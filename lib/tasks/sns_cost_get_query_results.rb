class SnsCostGetQueryResults

  def self.execute
    puts 'Execute sns_cost_get_query_results.rb'

    # 送信済みかつ送信ステータス&送信コスト未取得 (１番古いSMS送信日時を取得のため昇順並び替え)
    need_get_query_messages = SendMessage.where(send_status: nil, send_cost: nil, send_type: :sms).where.not(query_id: nil)
    query_ids = need_get_query_messages.pluck(:query_id).uniq
    save_count = 0

    unless query_ids.empty?
      query_ids.each do |query_id|
        begin
          client = Aws::AwsUtility.CloudWatchLogs_client
          get_query_results_resp = client.get_query_results({
            query_id: query_id
          })
  
          if get_query_results_resp.status === 'Complete'
            # クエリ結果保存
            get_query_results_resp.results.each do |result|
              status = nil
              message_id = nil
              cost = nil
  
              result.each do |log|
                case log.field
                when 'status' then
                  status = log.value.downcase
                when 'notification.messageId' then
                  message_id = log.value
                when 'delivery.priceInUSD' then
                  cost = log.value
                end
              end
  
              send_message = SendMessage.find_by(message_id: message_id)
              send_message.send_status = status
              send_message.send_cost = cost
              if send_message.save
                save_count += 1
                puts "Save cost and status. message_id: #{message_id}"
              end
            end
          end
        rescue => exception
          puts "Error: #{exception}, File: sns_cost_get_query_results.rb"
        end
      end
      puts "Result: Save #{save_count} cost and status"
    else
      puts 'Result: There was no query'
    end
  end

end

SnsCostGetQueryResults.execute
