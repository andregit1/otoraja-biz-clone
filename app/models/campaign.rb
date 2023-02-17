class Campaign < ApplicationRecord
  belongs_to :campaign_type
  belongs_to :shop, optional: true
end
