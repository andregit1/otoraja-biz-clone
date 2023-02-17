class Member::MaintenanceLogDetailsController < Member::MemberController
  def list
    maintenance_log_ids = MaintenanceLog.where(checkin_id: Checkin.where(customer: @customer).where(deleted: false)).pluck(:id)
    @items = MaintenanceLogDetail.select(:name).where(maintenance_log_id: maintenance_log_ids).group(:name).order(name: :asc)
  end
end
