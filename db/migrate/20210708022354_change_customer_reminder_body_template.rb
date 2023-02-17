class ChangeCustomerReminderBodyTemplate < ActiveRecord::Migration[5.2]
  def change
    reminder = ReminderBodyTemplate.find_by(title: 'customer reminder')
    unless reminder.nil?
      reminder.template = 'Motor Anda sudah terasa berat? Waktunya servis di [shop_name] supaya motor kembali ngaciiirrr…'
      reminder.save
    end
  end
end
