class Api::BikeModelController < Api::ApiController
  def model_auto_complete
    name = params[:term]
    maker = params[:maker]

    @models = BikeModel.joins(:maker).select('bike_models.name').where('bike_models.name LIKE ?',"%#{name}%")
    @models = @models.where('makers.name = ?',maker) unless maker.nil?
    render json: @models.to_json
  end
end
