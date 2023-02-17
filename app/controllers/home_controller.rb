class HomeController < ApplicationController
  def index
    if current_user.staff?
      redirect_to new_maintenance_log_path
    elsif current_user.admin_roles?
      redirect_to console_dashboard_index_path
    else
      redirect_to admin_dashboard_index_path
    end
  end
end
