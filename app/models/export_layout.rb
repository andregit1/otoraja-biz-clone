class ExportLayout < ApplicationRecord
  belongs_to :export_pattern
  belongs_to :export_type

  has_many :export_layout_columns
  has_many :export_columns, :through => :export_layout_columns
  has_many :export_masking_rules, :through => :export_layout_columns

  accepts_nested_attributes_for :export_layout_columns, reject_if: :reject_export_layout_column, allow_destroy: true

  def reject_export_layout_column(attributes)
    attributes[:export_column_id].blank? && attributes[:order].blank?
  end
end
