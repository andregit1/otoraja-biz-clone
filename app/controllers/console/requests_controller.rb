class Console::RequestsController < Console::ApplicationConsoleController
  before_action :set_request, only: [:show]

  def new_application
    @q = NewContractRequest.ransack(search_params)
    @requests = @q.result.order("id DESC").page(params[:page]).per(20)
  end

  def update_new_application_status
    @request = NewContractRequest.find(params[:id])
    @request.status = params[:status]

    @request.save
    redirect_back(fallback_location: console_requests_new_application_path)
  end

  def renewal_application
    @requests = NewContractRequest.all.order("id DESC").page(params[:page]).per(20)
  end


  private
    def set_request
      @request = NewContractRequest.find(params[:id])
    end

    def search_params
      params.fetch(:q, {}).permit(status_in:[])
    end
end
