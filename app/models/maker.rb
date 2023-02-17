class Maker < ApplicationRecord
    has_many :bike_model
    validates :name, presence: true
end
