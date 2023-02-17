class Console::BikeModelsController < Console::ApplicationConsoleController

  def index
    @makers = Maker.all.order(order: 'asc')
    @select_maker = params[:select_maker].present? ? @makers.find(params[:select_maker]) : @makers.first
    @q = BikeModel.ransack(params[:q])
    @bike_models = @q.result
  end

  def new
    @bike_model = BikeModel.new()
  end

  def create
    @bike_model = BikeModel.new(bike_model_params)
    if @bike_model.save
      redirect_to console_bike_models_path, notice: 'Model was successfully created.'
    else
      render :new
    end
  end

  def edit
    @bike_model = BikeModel.find_by_id(params[:id])
  end

  def update
    @bike_model = BikeModel.find_by_id(params[:id])
    if @bike_model.update(bike_model_params)
      redirect_to console_bike_models_path, notice: 'Model was successfully updated.'
    else
      render :edit
    end
  end

  private
    def bike_model_params
      params.require(:bike_model).permit(:maker_id, :name)
    end

end
