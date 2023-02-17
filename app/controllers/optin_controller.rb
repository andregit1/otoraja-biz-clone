class OptinController < ActionController::Base
  before_action :authenticate_user!, except: [:new, :create]

  def new

  end

  def update

  end

  def get

  end

  def is_optin

  end

  def do_optin
    permitted_params = params.require(:whats_app_optin).permit(:customer_id, :service_id, :invite_id)
    if request.post?
        @customer_id = permitted_param[:customer_id]
        @service_id = permitted_param[:service]
        @invite_id = permitted_params[:invite_id]
        WhatsAppOptin.create(
            customer_id: @customer_id,
            service_id: @service_id,
            invite_id: @invite_id
        )
    end
  end

  def send_invite

  end


  private

end