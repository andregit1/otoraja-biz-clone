class CustomerUpload
  include ActiveModel::Model

  attr_accessor :file
  attr_accessor :shop_id

  validate :presence?
  validate :valid_content_type?
  validate :valid_format?
  validate :valid_data?

  COLUMNS = ["country_code","tel","name","number_plate_area","number_plate_number","number_plate_pref","expiration_month","expiration_year","maker","model","color"]

  def initialize(attribute = {})
    @file = attribute.fetch(:file, nil)
    @shop_id = attribute.fetch(:shop_id, nil)
    @spreadsheet = @file.blank? ? nil : open_spreadsheet(@file)
  end

  def presence?
    errors.add(:file, "does not exist. ") if @file.blank?
  end

  def valid_content_type?
    return if @file.blank?

    extension = ['text/csv', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
    errors.add(:file, "type is not allowed. Allowed formats are csv and xlsx(xls).") unless @file&.content_type.in?(extension)
  end

  def valid_format?
    return if @spreadsheet.nil?

    errors.add(:file, "format is not allowed.") unless COLUMNS.to_set.subset?(@spreadsheet.first.to_set)
  end

  def valid_data?
    return if errors.size > 0 || @spreadsheet.nil?

    rows = parse(@spreadsheet)
    tmp_customers = []
    
    makers = Maker.all.map{|h| h[:name]}

    rows.each_with_index do |row, index|
      line = index + 2

      if row[:country_code].nil?
        errors.add(:file, "Line #{line}: Country code does not exist.")
        next
      end

      if row[:tel].nil?
        errors.add(:file, "Line #{line}: Tel does not exist.")
        next
      end

      tel = [row[:country_code],row[:tel]].join
      phone = Phonelib.parse(tel)
      unless phone.valid?
        errors.add(:file, "Line #{line}: Invalid format phone number.")
      else
        row[:tel] = phone.international(false)
      end

      customer = Customer.find_by(tel: row[:tel])
      unless customer.nil?
        row[:id] = customer.id
      end

      #NumberPlateAreaチェック
      if row[:number_plate_area].present?
        unless MaintenanceLog.number_plate_areas.keys.include?(row[:number_plate_area])
          errors.add(:file, "Line #{line}: Number Plate Area is invalid.")
        end
      end

      #NumberPlateNumberチェック
      if (/\A[0-9]{0,4}\z/ =~ row[:number_plate_number].to_s).nil?
        errors.add(:file, "Line #{line}: Number Plate Number is invalid.")
      end

      #NumberPlatePrefチェック
      if row[:number_plate_pref].present?
        if row[:number_plate_pref].size > 3
          errors.add(:file, "Line #{line}: Number Plate Pref is invalid.")
        end
      end

      #Makerチェック
      if row[:maker].present?
        unless makers.include?(row[:maker])
          errors.add(:file, "Line #{line}: Maker is invalid.")
        end
      end

      if row[:color].present?
        unless MaintenanceLog.colors.keys.include?(row[:color])
          errors.add(:file, "Line #{line}: Color is invalid.")
        end
      end

      tmp_customers << row

    end

    @customers = rows
  end

  def get_customers
    @customers
  end

  private
    def open_spreadsheet(file)
      case File.extname(file.original_filename)
        when '.csv'  then Roo::CSV.new(file.path)
        when '.xls'  then Roo::Excel.new(file.path)
        when '.xlsx' then Roo::Excelx.new(file.path)
      end
    end

    def parse(spreadsheet)
      spreadsheet.parse(
        country_code: "country_code",
        tel: "tel",
        name: "name",
        number_plate_area: "number_plate_area",
        number_plate_number: "number_plate_number",
        number_plate_pref: "number_plate_pref",
        expiration_month: "expiration_month",
        expiration_year: "expiration_year",
        maker: "maker",
        model: "model",
        color: "color",
      )
    end
end
