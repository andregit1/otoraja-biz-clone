class VaCodeArea < ApplicationRecord
    has_many :subscriptions
    belongs_to :province
end
