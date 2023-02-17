class Pdf::ViewerController < ApplicationController
  layout 'viewer'
  def index
    response.set_header("Accept-Language", "id")
    @path = params[:path]
    @back = nil
    if params[:back] == 'new_maintenance_log'
      @back = new_maintenance_log_path
    end
  end
end
