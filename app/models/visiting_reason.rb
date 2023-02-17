class VisitingReason < ApplicationRecord
  has_many :shop_visiting_reasons
  has_many :shops, through: :shop_visiting_reasons

  scope :displayable, ->(shop_ids) {
    joins(:shop_visiting_reasons).where(shop_visiting_reasons: { shop_id: shop_ids, display: 1 }).order('shop_visiting_reasons.order ASC')
  }

  scope :by_checkin_id, ->(checkin_id) {
    shop_id  = Checkin.where(id:checkin_id).select(:shop_id)
    VisitingReason.displayable(shop_id).select(:visiting_reason_id, :order, :id, :name, :shop_id).distinct
  }
end
