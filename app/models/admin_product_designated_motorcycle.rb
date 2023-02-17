class AdminProductDesignatedMotorcycle < ApplicationRecord
  belongs_to :bike_model
  belongs_to :admin_product
end
