class UpdateWhatsAppMessageStatus
  def self.execute
    @client = Aws::AwsUtility.DynamoDB_client

    poll_history = PollingHistory.find_by(poll: :whats_app_outbound_messages)
    @last_execution = poll_history&.executed_at&.to_i
    @current_execution = (Time.now).to_i

    new_items = SendMessage.where("send_type = ? and send_status != ? and message_id IS NOT NULL", SendMessage.send_types[:wa], "read")
    new_items.each do |item|
      begin
        params = get_params(item.message_id)
        item_list = @client.query(params)

        item_list.items.each do |message_status|
          item.update(send_status: message_status["status"])
        end
      rescue => exception
        puts "#{exception} file: update_whats_app_message_status.rb"
        puts exception.backtrace.join("\n")
      end
    end
    poll_history.update(executed_at: Time.at(@current_execution).to_datetime)
    puts "Message status updates complete."
  end

  def self.get_params(message_id)
    params = {
      table_name: "whats-app-outbound-messages",
      key_condition_expression: "#id = :message_id and #time between :start_time and :end_time",
      expression_attribute_names: {
        "#id" => "message_id",
        "#time" => "timestamp"
        },
      expression_attribute_values: {
        ":message_id" => message_id,
        ":start_time" => @last_execution,
        ":end_time" => @current_execution
      }
    }
  end
end

UpdateWhatsAppMessageStatus.execute
