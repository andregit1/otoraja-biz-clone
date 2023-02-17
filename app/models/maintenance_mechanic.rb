class MaintenanceMechanic < ApplicationRecord
  belongs_to :maintenance_log_detail, optional: true
  belongs_to :shop_staff
end
