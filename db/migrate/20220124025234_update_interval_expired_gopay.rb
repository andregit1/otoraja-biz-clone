class UpdateIntervalExpiredGopay < ActiveRecord::Migration[5.2]
  def change
    gopay = PaymentType.find_by(name: 'gopay')
    gopay.update(expiration_interval: 1)
  end
end
