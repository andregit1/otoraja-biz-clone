class ExportPattern < ApplicationRecord
  has_many :export_layouts
  has_many :export_masking_rules
end
