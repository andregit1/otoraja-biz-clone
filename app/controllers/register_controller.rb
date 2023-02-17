class RegisterController < ActionController::Base
  include Rails.application.routes.url_helpers

  before_action :build_country_code_list
  before_action :check_captcha, only: [:create]
  before_action :set_regencies
  layout 'devise'

  def new
    @request = NewContractRequest.new
    render :new, locals: { invalid: false }
  end

  def create
    begin
      @request = NewContractRequest.new(request_params)
      @request.tel =  ApplicationController.helpers.sanitizePhoneNumber(@request.tel)
      
      if @request.save
        new_user = ShopGroup.bulk_create(@request)
        token = Token.create_new_contract_request(new_user.id)

        if Rails.env.production?
          url = "https://biz.otoraja.id/users/sign_in?uuid=#{token.uuid}"
        elsif Rails.env.staging?
          url = "https://stg-biz.otoraja.id/users/sign_in?uuid=#{token.uuid}"
        else
          url = "http://localhost:3000/users/sign_in?uuid=#{token.uuid}"
        end
        status = 'sent'
        begin
          ActionMailer::Base.mail(
            from: "noreply@otoraja.id",
            to: @request.email,
            subject: t('message.register.thanks.subject'),
            body: t('message.register.thanks.body', shop_name: @request.shop_name, email: @request.email, url: url, password: new_user.password),
          ).deliver

        rescue => e
          logger.error(e)
          status = nil
        end

        SendMessage.create(
          from: "noreply@otoraja.id",
          to: @request.email,
          subject: t('message.register.thanks.subject'),
          body: t('message.register.thanks.body', shop_name: @request.shop_name, email: @request.email, url: url, password: new_user.password),
          send_type: SendMessage.send_types[:email],
          send_purpose: SendMessage.send_purposes[:shop_register_ty_mail],
          send_datetime: DateTime.now, 
          send_status: status
        )

        redirect_to register_thank_you_path, flash: {info: 'success', hash: token.uuid}
      else
        @request.tel = request_params[:tel]
        redirect_to console_requests_new_application_path, flash: {danger: 'The request is invalid'}
      end
    rescue => e
      puts e
      render :new, locals: { invalid: true }
    end
  end

  def thank_you
  end

  private
    def set_regencies
      @regencies ||= Regency.all
    end

    def build_country_code_list
      @country_code_list = Settings.country_phone_code
    end

    def request_params
      params.fetch(:new_contract_request, {}).permit(:name, :email, :phone_country_code, :tel, :shop_name, :is_otoraja_biz, :is_otoraja_bp, :referral, :regency_id, :distric_id)
    end

    def international_phone_number
      return if request_params[:phone_country_code].blank? || request_params[:tel].blank?

      tel = request_params[:phone_country_code] + request_params[:tel]
      phone = Phonelib.parse(tel)
      if phone.valid?
        tel = phone.international(false) 
      end
      tel
    end

    def check_captcha
      unless verify_recaptcha
        redirect_to new_register_path
      end
    end
end
