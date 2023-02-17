class ChangePhoneNumberVerificationController < ApplicationController
  layout 'change_phone_number_verification'

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :set_token

  def show
    if @token
      if @token.expired_at > DateTime.now.in_time_zone('Jakarta')
        begin
          @token.customer.update_columns(tel: @token.customer.tmp_tel, wa_tel: @token.customer.tmp_tel, tmp_tel: nil, token_request_count: 0, token_locked_at: nil) 
          @token.update_columns(expired_at: DateTime.now.in_time_zone('Jakarta'))
          Customer.es_import_by_id(@token.customer.id)
        rescue => e
          puts e
        end
      end
    end
  end

  private
  
  def set_token
    @token ||= Token.find_by(
      uuid: uuid, 
      token_purpose: :change_phone_number, 
      expired_at: DateTime.now.in_time_zone('Jakarta')..DateTime::Infinity.new
    )
  end
  
  def uuid
    params[:uuid]
  end
end
