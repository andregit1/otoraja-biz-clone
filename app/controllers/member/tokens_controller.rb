class Member::TokensController < Member::MemberController
  include ChangeTel

  skip_before_action :set_header, only: [:create_token_email, :create_confirm_sms_token, :update_expired_at]

  def show
    checkin_id = Checkin.where(id: params[:checkin_id]).where(customer: @customer).where(deleted: false).select(:id)
    @token = Token.find_by(checkin_id: checkin_id, token_purpose: :questionnaire)
    if @token
      if @token.expired_at < DateTime.now
        not_found
        @answers_rate = Answer.find_by(questionnaire_id: Questionnaire.where(checkin_id: checkin_id).select(:id))
      end
    else
      not_found
    end
  end

  def create_token_email
    # Customer取得
    customer = Customer.find_by(email: params[:email])
    if customer.present?
      create_token_for_change_tel(customer)
    else
      token_not_found
    end
  end

  def create_confirm_sms_token
    # Customer取得
    customer = Customer.find_by(id: Token.where(uuid: params[:uuid]).select(:customer_id))
    create_token_and_send_sms(customer, params[:tmp_tel])
  end

  def create_sms_token_for_primary
    create_token_and_send_sms(@customer, params[:tmp_tel])
  end

  def update_expired_at
    token = Token.find_by(uuid: params[:uuid])
    if token
      if token.expired_at < DateTime.now
        token_not_found
      else
        token.expired_at = DateTime.now
        token.save
      end
    else
      token_not_found
    end
  end

  def send_email
    create_token_and_send_email(@customer, params[:tmp_email])
  end

  private
    def not_found
      @token = {
        id: '',
        uuid: ''
      }
    end

    def token_not_found
      raise ActionController::RoutingError.new('Not Found')
    end

end
