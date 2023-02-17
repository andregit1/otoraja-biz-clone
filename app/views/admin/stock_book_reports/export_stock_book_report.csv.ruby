require 'csv'

CSV.generate do |csv|
  column_names = %w(No Nama_Produk Produk_Kategori Stok_Awal Stok_Masuk Stok_Keluar Stok_Akhir Harga_Modal Nilai_Stok)
  csv << column_names
  @stock_products.each_with_index do |item, index|
    column_values = [
      index + 1,
      item.shop_alias_name,
      item.pc_name,
      item.last_stock.to_i - item.stock_in.to_i - item.stock_out.to_i,                                     
      item.stock_in.to_i,
      item.stock_out.to_i,
      item.last_stock.to_i,
      item.last_average_price.to_i,
      item.last_average_price.to_i * item.last_stock.to_i
    ]
    csv << column_values
  end
end
