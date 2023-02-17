class ImportDummyData20191001
  def self.execute
    checkins = Checkin.where(shop_id: 156).where('datetime <= ?', Date.today - 40.days) + Checkin.where(shop_id: [223, 240]).where('datetime <= ?', Date.today - 25.days) + Checkin.where(shop_id: 244).where('datetime <= ?', Date.today - 55.days)

    str = 'auto create'
    now = DateTime.now
    checkins.each do |checkin|
      send_message = SendMessage.create(to: str, body: str, send_type: :auto_create, send_purpose: :customer_remind, send_datetime: now, sent_at: now)
      CustomerReminderLog.create(send_message: send_message, customer: checkin.customer, checkin: checkin)
    end
  end
end

ImportDummyData20191001.execute
