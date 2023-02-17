class BikeModel < ApplicationRecord
    belongs_to :maker
    validates :name, presence: true
end
