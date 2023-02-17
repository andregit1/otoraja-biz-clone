class ExportColumn < ApplicationRecord
  belongs_to :export_type

  has_many :export_layout_columns
end
