class Console::FacilitiesController < Console::ApplicationConsoleController
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  def index
    @facilities = Facility.all
  end

  def show
  end

  def new
    @facility = Facility.new
  end

  def edit
  end

  def create
    @facility = Facility.new(facility_params)

    if @facility.save
      redirect_to console_facilities_path, notice: 'Facility was successfully created.' 
    else
      render :new
    end
  end

  def update
    @facility.assign_attributes(facility_params)

    if @facility.save
      redirect_to console_facilities_path, notice: 'Facility was successfully updated.'
    else
      render :edit
    end
  end

  # def destroy
  #   @console_facility.destroy
  #   respond_to do |format|
  #     format.html { redirect_to console_facilities_url, notice: 'Facility was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def set_facility
      @facility = Facility.find(params[:id])
    end

    def facility_params
      params.fetch(:facility, {}).permit(
        :name
      )
    end
end
