class Member::MaintenanceLogsController < Member::MemberController
  def show
    logger.debug("params: " + params[:maintenance_log_id])
    logger.debug("@customer: " + @customer.inspect)
    @maintenance_log = MaintenanceLog.find_by(id: params[:maintenance_log_id], checkin: Checkin.where(customer: @customer).where(deleted: false))
    logger.debug("@maintenance_log: " + @maintenance_log.inspect)
  end
end
