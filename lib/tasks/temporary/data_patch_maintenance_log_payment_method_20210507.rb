class DataPatchMaintenanceLogPaymentMethod20210507
  def self.execute
    #payment method record was not created for maintenance log id　40071
    #use value maintenance log `total_price` for maintenance_log_payment_method `amount`
    ActiveRecord::Base.transaction do 
      begin
        puts 'Execute data_patch_maintenance_log_payment_method_20210507.rb'
        maintenance_log = MaintenanceLog.find(40071)
        record = MaintenanceLogPaymentMethod.new
        record.maintenance_log_id = maintenance_log.id
        record.payment_method = PaymentMethod.find(1)
        record.amount = maintenance_log.total_price
        record.created_staff_id = maintenance_log.created_staff_id
        record.created_staff_name = maintenance_log.created_staff_name
        record.updated_staff_id = maintenance_log.updated_staff_id
        record.updated_staff_name = maintenance_log.updated_staff_name
        record.created_at = maintenance_log.created_at
        record.updated_at = maintenance_log.updated_at
        record.save
        puts 'Finished data_patch_maintenance_log_payment_method_20210507'
      rescue => e
        puts "error data_patch_maintenance_log_payment_method_20210507 #{e.message}", e.backtrace
      end
    end
  end
end

DataPatchMaintenanceLogPaymentMethod20210507.execute