class TransactionLog < ApplicationRecord
  belongs_to :subscription, optional: true

  attr_accessor :payment_date

  class << self    
    def set_callback(params)
      transaction_log = self.find_by(transaction_id: params[:transaction_id], is_paid: false)
      if transaction_log.present?
        return transaction_log.set_status(params) 
      else
        return {message: 'TRANSACTION NO FOUND', status: :unprocessable_entity}
      end
    end  
  end
  
  def set_status(params)
    self.payment_date = params[:transaction_updated_at]
    self.update!(callback_response: params.to_json)
    self.send("#{params[:status]}" )
  end

  def invoice_number_generator(params)
    code = params.fee.present? && params.fee == 10000 ?  "TEST" : "RCP"
    year = Date.today.to_s[2,2].to_i
    month = sprintf("%02d",Date.today.month)
    number = sprintf("%04d", Subscription.where("invoice_number like '#{code}-#{year}%' ").count + 1)
    invoice_number = "#{code}-#{year}#{month}#{number}"
  end

  private
  
  def settlement
    subscription_params = {
      payment_date: ApplicationController.helpers.formatedDateTz(self.payment_date , 'Jakarta'),
      invoice_number: self.invoice_number_generator(self.subscription)
    }

    self.update!(is_paid: true)
    self.subscription.update_finalization(subscription_params)
    self.subscription.send_payment_received_notification

    return {message: 'TRANSACTION UPDATED', status: :ok} 
  end

  def cancel
    self.subscription.cancel_subscription('Cancel by payment gateway service')
    return {message: 'TRANSACTION CANCELED', status: :ok} 
  end

  def expire
    self.subscription.update!(status: :payment_gateway_expired)
    return {message: 'TRANSACTION UPDATED', status: :ok} 
  end

end
