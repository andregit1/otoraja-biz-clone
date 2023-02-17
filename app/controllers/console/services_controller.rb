class Console::ServicesController < Console::ApplicationConsoleController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.all
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to console_services_path, notice: 'Service was successfully created.' 
    else
      render :new
    end
  end

  def update
    @service.assign_attributes(service_params)

    if @service.save
      redirect_to console_services_path, notice: 'Service was successfully updated.'
    else
      render :edit
    end
  end

  # def destroy
  #   @service.destroy
  #   respond_to do |format|
  #     format.html { redirect_to console_shop_groups_url, notice: 'Shop group was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def set_service
      @service = Service.find(params[:id])
    end

    def service_params
      params.fetch(:service, {}).permit(
        :name
      )
    end
end