class MaintenanceLogDetailRelatedProduct < ApplicationRecord
  include StockManagementConcern
  belongs_to :maintenance_log_detail, optional: true
  belongs_to :shop_product
end
