class ExportType < ApplicationRecord
  has_many :export_columns
  has_many :export_layouts
end
