class Callback::TransactionLogController < Callback::ApiController
  include Rails.application.routes.url_helpers
 
  protect_from_forgery :except => [:update_status]

  def update_status
    begin
      ActiveRecord::Base.transaction do
        transaction = TransactionLog.set_callback(transaction_params) 
        json_response(transaction[:message], transaction[:status])
      end
    rescue => exception
      json_response(exception, :unprocessable_entity)
    end
  end

  private

  def json_response(message, status)
    response = {message: message}
    render json: response, status: status
  end

  def transaction_params
    params.permit(
      :id,
      :transaction_id,
      :order_id,
      :payment_type_id,
      :is_email,
      :is_push_notification,
      :is_refund,
      :is_paid,
      :is_partial,
      :total_receive,
      :total_paid,
      :status,
      :transaction_updated_at
    )
  end
end