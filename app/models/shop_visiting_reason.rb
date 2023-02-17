class ShopVisitingReason < ApplicationRecord
  belongs_to :shop
  belongs_to :visiting_reason
end
