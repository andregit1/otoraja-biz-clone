class Console::PaymentGatewayController < Console::ApplicationConsoleController
  def index
    @payment_gateways = PaymentGateway.all
  end

  def search_shop
    shop_list = PaymentGateway.search_shop(params);
    render :json => {:shop_list => shop_list}
  end

  def update
    error_handle = PaymentGateway.bulk_update(payment_params)
    if error_handle.empty?
      redirect_to console_payment_gateway_path, notice: 'Data berhasil diubah'
    else
      @payment_gateways = PaymentGateway.all
      render :index
    end
  end

  def payment_params
    params.require(:payment_gateway).permit(
      id: [:is_active,:payment_types_attributes => [:id, :is_active, :is_use_all,  :shop_list =>[]]]
    )
  end
end