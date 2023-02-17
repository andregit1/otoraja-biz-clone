require 'csv'

CSV.generate do |csv|
  column_names = %w(Tanggal Dibayarkan_kepada Nilai Referal Keterangan)
  csv << column_names
  @shop_expenses.each do |item|
    column_values = [
      formatedDateTz(item.expense_date, 'Jakarta'),
      item.supplier.name,
      formatedAmount(item.value),                                  
      item.no_ref,
      item.description,
    ]
    csv << column_values
  end
end