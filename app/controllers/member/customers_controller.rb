class Member::CustomersController < Member::MemberController
  include AwsCognito
  skip_before_action :set_header, only: [:get_change_tel, :update_tel, :get_change_mail, :update_email]

  def info
    @bikes = OwnedBike.where(customer: @customer)
  end

  def update
    @customer.update(
      name: params[:name],
      tel: params[:tel],
      email: params[:email]
    )
  end

  def save_settings
    permited_params = params.require(:customer).permit(:receipt_type, :send_type, :wa_tel, :send_dm, wa_services: [])
    @customer.update(
      receipt_type: params[:receipt_type],
      send_type: params[:send_type],
      wa_tel: params[:wa_tel],
      send_dm: params[:send_dm]
    )
  end
  
  def update_mypage_terms_agreed_at
    @customer.mypage_terms_agreed_at = DateTime.now
    @customer.save
  end

  def get_change_tel
    get_customer_form_uuid(params[:uuid])
  end

  def update_tel
    customer = Customer.find_by(id: params[:id])
    # Cognitoを更新する
    update_cognito_phone_number(customer.tel, customer.tmp_tel)
    # DBを更新
    customer.tel = customer.tmp_tel
    customer.tmp_tel = ''
    customer.save
  end

  def get_change_mail
    get_customer_form_uuid(params[:uuid])
  end

  def update_email
    customer = Customer.find_by(id: params[:id])
    customer.email = customer.tmp_email
    customer.tmp_email = ''
    customer.save
  end

  private
    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def get_customer_form_uuid(uuid)
      token = Token.find_by(uuid: uuid)
      if token
        if token.expired_at < DateTime.now
          not_found
        else
          @customer = Customer.find_by(id: token.customer_id)
          token.expired_at = DateTime.now
          token.save
        end
      else
        not_found
      end
    end

end
