class ExportMaskingRule < ApplicationRecord
  belongs_to :export_layout_column

  def masking(value)
    return value unless self.use_masking
    
    value = value.to_s
    value = value.dup if value.frozen?  # 凍結状態だと置換不可のため解凍

    top_no_masking_digits = self.top_no_masking_digits || 0
    last_no_masking_digits = self.last_no_masking_digits || 0

    if value.size > top_no_masking_digits + last_no_masking_digits
      top_no_masking_str = value[0, top_no_masking_digits]
      last_no_masking_str = value[value.size - last_no_masking_digits, value.size]

      value.sub!(/\A#{top_no_masking_str}/, '')
      value.sub!(/#{last_no_masking_str}\z/, '')

      value = top_no_masking_str + ('*' * value.size) + last_no_masking_str
    end
    value
  end
end
