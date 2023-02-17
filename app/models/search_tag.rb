class SearchTag < ApplicationRecord
  validates :tag, length: { maximum: 255 }, uniqueness: true, presence: true
end
