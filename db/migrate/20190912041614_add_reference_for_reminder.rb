class AddReferenceForReminder < ActiveRecord::Migration[5.2]
  def change
    add_reference :purchase_histories, :maintenance_log_detail, index: false, :after => :reminded
    add_reference :customer_reminder_logs, :checkin, index: false, :after => :customer_id

    # 過去にチェックアウトした顧客に対して、顧客リマインドを送信済みデータとして登録しておく
    # str = 'auto create'
    # now = DateTime.now
    # Checkin.where.not(checkout_datetime: nil).each do |checkin|
    #   send_message = SendMessage.create(to: str, body: str, send_type: :auto_create, send_purpose: :customer_remind, send_datetime: now, sent_at: now)
    #   CustomerReminderLog.create(send_message: send_message, customer: checkin.customer, checkin: checkin)
    # end
  end
end
