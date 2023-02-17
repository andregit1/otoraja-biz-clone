class AdministrativeAreasController < ApplicationController
  layout false

  protect_from_forgery with: :exception
  skip_before_action :authenticate_user!

  def regencies
    regencies = Regency.ransack(params[:q]).limit(10)
    render json: regencies.result.order(:name)
  end

  def districs
    districs = Distric.select("id, name as text").where(regency_id: params[:regency_id]).order(:name)
    render json: districs.all
  end
end