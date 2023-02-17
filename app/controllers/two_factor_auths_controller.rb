class TwoFactorAuthsController < ActionController::Base
    before_action :authenticate_user!, except: [:new, :create]

    def new
        @user = User.find_by(user_id: session[:otp_user_id])
        unless @user.otp_secret
            @user.otp_secret = User.generate_otp_secret
            @user.save!
        end
        if session[:mfa_error]
            @error = session[:mfa_error]
        end
        @qr_code = build_qr_code

        session.delete(:mfa_error)

    end

    def create
        @user = User.find_by(user_id: session[:otp_user_id])

        return unless @user

        session[:otp_attempt] = params[:otp_attempt]
        redirect_to root_path and return

    end

    def destroy
        @user = User.find_by(user_id: session[:otp_user_id])
        @user.update_attributes(
            otp_required_for_login: false,
            encrypted_otp_secret: nil,
            encrypted_otp_secret_iv: nil,
            encrypted_otp_secret_salt: nil,
        )

        redirect_to_root_path

    end

    private 

    def build_qr_code

        label = @user.user_id

        issuer = 'otoraja'
        uri = @user.otp_provisioning_uri(label, issuer: issuer)
        qrcode = RQRCode::QRCode.new(uri)
        qrcode.as_svg(
            offset: 0,
            color: '000',
            shapre_rendering: 'crispEdges',
            module_size: 2
        )

    end

end