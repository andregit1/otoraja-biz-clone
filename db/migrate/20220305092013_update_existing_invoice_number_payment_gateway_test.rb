class UpdateExistingInvoiceNumberPaymentGatewayTest < ActiveRecord::Migration[5.2]
  def change
    subscriptions_test = Subscription.where("invoice_number like ? and fee = ?", "RCP-22%", 10000)
    subscriptions_test.each do |subscription|
      subscription.update(invoice_number: subscription.invoice_number.gsub('RCP', 'TEST'))
    end
  end
end
