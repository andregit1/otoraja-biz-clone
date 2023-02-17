class ImportCustomersExportPuttern20191113
  def self.execute
    pattern_general = ExportPattern.create(name: 'General')
    pattern_jpn = ExportPattern.create(name: 'JPN Admin')
    pattern_idn = ExportPattern.create(name: 'IDN Admin')

    type_customers = ExportType.create(name: 'CustomerList')

    ExportLayout.create(name: 'General Customers CSV', export_pattern: pattern_general, export_type: type_customers)
    ExportLayout.create(name: 'JPN Admin Customers CSV', export_pattern: pattern_jpn, export_type: type_customers)
    ExportLayout.create(name: 'IDN Admin Customers CSV', export_pattern: pattern_idn, export_type: type_customers)
    
    ExportColumn.create(name: 'name', export_type: type_customers)
    ExportColumn.create(name: 'tel', export_type: type_customers)
    ExportColumn.create(name: 'email', export_type: type_customers)
    ExportColumn.create(name: 'gender', export_type: type_customers)
    ExportColumn.create(name: 'cognito_id', export_type: type_customers)
    ExportColumn.create(name: 'cognito_pw', export_type: type_customers)
    ExportColumn.create(name: 'region_id', export_type: type_customers)
    ExportColumn.create(name: 'provincve_id', export_type: type_customers)
    ExportColumn.create(name: 'regencie_id', export_type: type_customers)
    ExportColumn.create(name: 'send_dm', export_type: type_customers)
    ExportColumn.create(name: 'terms_agreed_at', export_type: type_customers)

    ExportColumn.where(export_type: type_customers).each_with_index do |column, index|
      ExportLayout.all.each do |layout|
        layout_column = ExportLayoutColumn.create(export_layout: layout, export_column: column, order: index + 1)
        ExportMaskingRule.create(export_layout_column: layout_column, use_masking: true)
      end
    end
  end
end

ImportCustomersExportPuttern20191113.execute
