class Regency < ApplicationRecord
  belongs_to :province
  has_many :districs
  self.inheritance_column = :_type_disabled

  def complete_name
    name
  end
end
