class CreateVaCodeAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :va_code_areas do |t|
      t.references :province, index: false
      t.integer :va_code
      t.string :area_name
      t.boolean :status, :null => false, :default => true
      t.timestamps
    end

    code_area = [
      [province_id: 2, va_code: 12, area_name: 'Sumatera Utara'],
      [province_id: 3, va_code: 13, area_name: 'Sumatera Barat'],
      [province_id: 4, va_code: 15, area_name: 'Jambi'],
      [province_id: 5, va_code: 14, area_name: 'Riau'],
      [province_id: 6, va_code: 17, area_name: 'Bengkulu'],
      [province_id: 8, va_code: 18, area_name: 'Lampung'],
      [province_id: 9, va_code: 19, area_name: 'Kepulauan Bangka Belitung'],
      [province_id: 10, va_code: 36, area_name: 'Kepulauan Riau'],
      [province_id: 14, va_code: 37, area_name: 'Jawa Tengah'],
      [province_id: 15, va_code: 39, area_name: 'Jawa Timur'],
      [province_id: 16, va_code: 38, area_name: 'DI Yogyakarta'],
      [province_id: 17, va_code: 51, area_name: 'Bali'],
      [province_id: 18, va_code: 52, area_name: 'Nusa Tenggara Barat'],
      [province_id: 19, va_code: 53, area_name: 'Nusa Tenggara Timur'],
      [province_id: 20, va_code: 61, area_name: 'Kalimantan Barat'],
      [province_id: 21, va_code: 63, area_name: 'Kalimantan Selatan'],
      [province_id: 22, va_code: 62, area_name: 'Kalimantan Tengah'],
      [province_id: 23, va_code: 64, area_name: 'Kalimantan Timur'],
      [province_id: 25, va_code: 75, area_name: 'Gorontalo'],
      [province_id: 26, va_code: 73, area_name: 'Sulawesi Selatan'],
      [province_id: 27, va_code: 76, area_name: 'Sulawesi Barat'],
      [province_id: 28, va_code: 74, area_name: 'Sulawesi Tenggara'],
      [province_id: 29, va_code: 72, area_name: 'Sulawesi Tengah'],
      [province_id: 30, va_code: 71, area_name: 'Sulawesi Utara'],
      [province_id: 31, va_code: 81, area_name: 'Maluku'],
      [province_id: 32, va_code: 82, area_name: 'Maluku Utara'],
      [province_id: 33, va_code: 91, area_name: 'Papua Barat'],
      [province_id: 34, va_code: 94, area_name: 'Papua'],
      [province_id: 11, va_code: 31, area_name: 'Central Jakarta'],
      [province_id: 11, va_code: 32, area_name: 'West Jakarta'],
      [province_id: 11, va_code: 33, area_name: 'South Jakarta'],
      [province_id: 11, va_code: 34, area_name: 'East Jakarta'],
      [province_id: 11, va_code: 35, area_name: 'North Jakarta'],
      [province_id: 12, va_code: 42, area_name: 'Kab. Tangerang'],
      [province_id: 12, va_code: 44, area_name: 'Other Banten Area'],
      [province_id: 12, va_code: 43, area_name: 'South Tangerang'],
      [province_id: 12, va_code: 41, area_name: 'Tangerang Kota'],
      [province_id: 13, va_code: 21, area_name: 'Depok'],
      [province_id: 13, va_code: 22, area_name: 'Bogor'],
      [province_id: 13, va_code: 23, area_name: 'Bandung'],
      [province_id: 13, va_code: 24, area_name: 'Cikarang'],
      [province_id: 13, va_code: 25, area_name: 'Karawang'],
      [province_id: 13, va_code: 26, area_name: 'Other West Java']
    ]

    VaCodeArea.create(code_area)
  end
end
