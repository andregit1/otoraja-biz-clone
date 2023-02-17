class Console::BikesController < Console::ApplicationConsoleController

  def index
    @q = Bike.ransack(params[:q])
    @bikes = @q.result.order(id: :desc).page(params[:page]).per(10)
  end

end
