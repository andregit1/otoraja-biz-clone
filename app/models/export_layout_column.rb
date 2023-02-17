class ExportLayoutColumn < ApplicationRecord
  belongs_to :export_column
  belongs_to :export_layout
  has_one :export_masking_rule, dependent: :destroy

  validates :order, presence: true

  accepts_nested_attributes_for :export_masking_rule, reject_if: :all_blank, allow_destroy: true
end
