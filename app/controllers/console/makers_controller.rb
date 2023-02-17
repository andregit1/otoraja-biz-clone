class Console::MakersController < Console::ApplicationConsoleController

  def index
    @makers = Maker.all.order(order: 'asc')
  end

  def new
    @maker = Maker.new()
  end

  def create
    @maker = Maker.new(maker_params)
    if @maker.save
      redirect_to console_makers_path, notice: 'Maker was successfully created.'
    else
      render :new
    end
  end

  def edit
    @maker = Maker.find_by_id(params[:id])
  end

  def update
    @maker = Maker.find_by_id(params[:id])
    if @maker.update(maker_params)
      redirect_to console_makers_path, notice: 'Maker was successfully updated.'
    else
      render :edit
    end
  end

  def order_update
    items = []
    for item in JSON.parse(params[:data]) do
      maker = Maker.find(item["id"])
      maker.update(order: item["order"])
      items << maker
    end
    render json: items
  end

  private
    def maker_params
      params.require(:maker).permit(:name, :order)
    end

end
