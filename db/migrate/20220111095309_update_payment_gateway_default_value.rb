class UpdatePaymentGatewayDefaultValue < ActiveRecord::Migration[5.2]
  def change
    begin
      ActiveRecord::Base.transaction do
        #Change default payment gateway to non-active 
        payment_gateway = PaymentGateway.find_by(is_active: true)
        payment_gateway.update!(is_active: false)

        #Change default payment type to non-active 
        payment_types = PaymentType.all
        payment_types.update_all(is_active: false)

        #Change expired interval from 5 minutes to 3 minutes
        payment_types_interval = PaymentType.where(expiration_interval: 5)
        payment_types_interval.update_all(expiration_interval: 3)

        #Set default value is_paid field to in transaction log
        change_column :transaction_logs, :is_paid, :boolean, default: false
      end
    rescue => e
      puts "error: #{e}"
      logger.error(e.message)
    end
  end
end
