class Api::ReceiptController < Api::ApiController
  include Checkout

  def resend_sms
    msg = resend_receipt_sms(policy_scope(Checkin).find(params[:checkin_id]))
    render :json => {msg: msg}
  end

end
