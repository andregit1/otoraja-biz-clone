class DataPatchMaintenanceLogDetail20210525
  def self.execute
    ActiveRecord::Base.transaction do 
      begin
        puts 'Execute data_patch_maintenance_log_detail_20210525.rb'
        maintenance_log_detail = MaintenanceLogDetail.find(128666)
        modified_name = '';
        maintenance_log_detail.name.each_char {|c|
          modified_name << c if c =~ /^[a-zA-Z0-9\s!-\/:-@\[-`{-~]*$/
        }
        maintenance_log_detail.name = modified_name
        maintenance_log_detail.save
        puts 'Finished data_patch_maintenance_log_detail_20210525'
      rescue => e
        puts "error data_patch_maintenance_log_detail_20210525 #{e.message}", e.backtrace
      end
    end
  end
end

DataPatchMaintenanceLogDetail20210525.execute