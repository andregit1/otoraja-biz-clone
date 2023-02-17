class MaintenanceMenu < ApplicationRecord
  belongs_to :maintenance_log_detail, optional: true
end
