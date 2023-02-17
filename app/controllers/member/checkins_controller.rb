class Member::CheckinsController < Member::MemberController
  def list
    checkin = Checkin.joins(:shop)
    relation = checkin.joins(maintenance_log: :maintenance_log_details)
      .where(customer_id: @customer.id)
      .where(deleted: false)
      .order(datetime: :desc)
    @checkins = relation
      .where('shops.name LIKE ?', "%#{params[:search]}%")
      .or(relation.where('maintenance_logs.maker LIKE ?', "%#{params[:search]}%"))
      .or(relation.where('maintenance_logs.model LIKE ?', "%#{params[:search]}%"))
      .or(relation.where('maintenance_logs.number_plate_area LIKE ?', "%#{params[:search]}%"))
      .or(relation.where('maintenance_logs.number_plate_number LIKE ?', "%#{params[:search]}%"))
      .or(relation.where('maintenance_logs.number_plate_pref LIKE ?', "%#{params[:search]}%"))
      .or(relation.where('maintenance_log_details.name LIKE ?', "%#{params[:search]}%"))
      .distinct

    if params[:maker].present? || params[:model].present? || params[:number_plate_area].present? || params[:number_plate_number].present? || params[:number_plate_pref].present?
      checkin_ids = MaintenanceLog
        .where(maker: params[:maker])
        .where(model: params[:model])
        .where(number_plate_area: params[:number_plate_area])
        .where(number_plate_number: params[:number_plate_number])
        .where(number_plate_pref: params[:number_plate_pref])
        .pluck(:checkin_id)
      @checkins = @checkins.where(id: checkin_ids).order(datetime: :desc)
    end

    if params[:item].present?

      checkin_ids = MaintenanceLog.where(id: MaintenanceLogDetail.where(name: params[:item]).pluck(:maintenance_log_id)).pluck(:checkin_id)
      @checkins = @checkins.where(id: checkin_ids).order(datetime: :desc)
    end
  end
end
