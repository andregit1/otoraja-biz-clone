class AdminProductUpload
  include ActiveModel::Model

  attr_accessor :file
  validate :presence?
  validate :valid_content_type?
  validate :valid_format?
  validate :valid_data?

  ADMIN_PRODUCT_COLUMNS = ["id", "product_category_id", "product_category_name", "product_no", "name", "item_detail", "brand_id", "brand_name", "variant_id", "variant_name", "tech_spec_id", "tech_spec_name", "default_remind_interval_day", "campaign_code"]

  def self.columns
    ADMIN_PRODUCT_COLUMNS
  end

  def initialize(attribute = {})
    @file = attribute.fetch(:file, nil)
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

    errors.add(:file, "format is not allowed.") unless ADMIN_PRODUCT_COLUMNS.to_set.subset?(@spreadsheet.first.to_set)
  end

  def valid_data?
    return if errors.size > 0 || @spreadsheet.nil?

    rows = parse(@spreadsheet)
    tmp_admin_products = []
    tmp_old_admin_products = []

    product_category_names = rows.map{|h| h[:product_category_name]}.uniq
    product_categories = ProductCategory.select("id,name").where(name: product_category_names).map{|k| [k.name,k.id]}.to_h

    brands = rows.map do |row|
      brand_name_converted = ApplicationController.helpers.convert_invalid_characters(row[:brand_name])
      brand = Brand.find_by("name LIKE ?", brand_name_converted)
      [brand, row[:brand_name]] if brand.present?
    end.uniq.compact

    variants = rows.map do |row|
      variant_name_converted = ApplicationController.helpers.convert_invalid_characters(row[:variant_name])
      variant = Variant.find_by("name LIKE ? AND product_category_id = ?", variant_name_converted, row[:product_category_id])
      [variant, row[:variant_name]] if variant.present?
    end.uniq.compact

    tech_specs = rows.map do |row|
      tech_spec_name_converted = ApplicationController.helpers.convert_invalid_characters(row[:tech_spec_name])
      tech_spec = TechSpec.find_by("name LIKE ? AND product_category_id = ?", tech_spec_name_converted, row[:product_category_id])
      [tech_spec, row[:tech_spec_name]] if tech_spec.present?
    end.uniq.compact

    product_ids = rows.map{|h| h[:id]}

    #IDが重複しているとき、エラーを返す
    errors.add(:file, "Duplicate product id") if product_ids.compact.count - product_ids.compact.uniq.count > 0

    rows.each_with_index do |row, index|
      line = index + 2
      product_category = product_categories.find{|k,v| k==row[:product_category_name]}
      category = ProductCategory.find_by_name(product_category.first)
      brand = brands.find{|brand| brand.last == row[:brand_name]}
      variant = variants.find{|variant| variant.last == row[:variant_name] && variant.first.product_category.id == category.id }
      tech_spec = tech_specs.find{|tech_spec| tech_spec.last == row[:tech_spec_name] && tech_spec.first.product_category.id == category.id }

      if row[:id].present?
        old_record = AdminProduct.find_by(id: row[:id])

        #レコード指定しているが、レコードが存在していない場合、エラーを返す
        errors.add(:file, "Line #{line}: Product ID \"#{row[:id]}\" does not exist.") if old_record.nil?
      else
        if row[:item_detail].nil?
          old_record = AdminProduct.joins(:product_category).joins(:brand).joins(:variant).joins(:tech_spec).find_by(name: row[:name],item_detail: [nil,""])
        else
          old_record = AdminProduct.joins(:product_category).joins(:brand).joins(:variant).joins(:tech_spec).find_by(name: row[:name],item_detail: row[:item_detail])
        end
      end

      #categoryがnilの場合、エラーを返す
      errors.add(:file, "Line #{line}: Product Category ID is required.") if row[:product_category_id].blank?
      errors.add(:file, "Line #{line}: \"#{row[:product_category_name]}\" is an unregistered category.") if product_category.nil?

      #nameが空の場合、エラーを返す
      errors.add(:file, "Line #{line}: Name is required.") if row[:name].blank?

      #default_remind_interval_dayが数値以外の場合、エラーを返す
      if row[:default_remind_interval_day].present? && (/\A[1-9][0-9]*\z/ =~ row[:default_remind_interval_day].to_s).nil?
        errors.add(:file, "Line #{line}: Default Remind Interval day \"#{row[:default_remind_interval_day]}\" is not an integer.")
      end

      #brand validation
      errors.add(:file, "Line #{line}: Brand is required") if row[:brand_name].blank? && category.brand_validation_required?
      errors.add(:file, "Line #{line}: Brand is unnecessary") if row[:brand_name].present? && category.brand_validation_unnecessary?

      #variant validation
      errors.add(:file, "Line #{line}: Variant is required") if row[:variant_name].blank? && category.variant_validation_required?
      errors.add(:file, "Line #{line}: Variant is unnecessary") if row[:variant_name].present? && category.variant_validation_unnecessary?

      #tech_spec validation
      errors.add(:file, "Line #{line}: Tech_Spec is required") if row[:tech_spec_name].blank? && category.tech_spec_validation_required?
      errors.add(:file, "Line #{line}: Tech_Spec is unnecessary") if row[:tech_spec_name].present? && category.tech_spec_validation_unnecessary?

      row[:id] = old_record[:id] unless old_record.nil?
      row[:product_category_id] = product_category[1] unless product_category.nil?
      row[:brand_id] = brand.first.id unless brand.nil?
      row[:variant_id] = variant.first.id unless variant.nil?
      row[:tech_spec_id] = tech_spec.first.id unless tech_spec.nil?
      tmp_admin_products << row
      tmp_old_admin_products << old_record
    end

    @admin_products = tmp_admin_products
    @old_admin_products = tmp_old_admin_products
  end

  def get_admin_products
    @admin_products
  end

  def get_old_admin_products
    @old_admin_products
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
        id: "id",
        product_category_id: "product_category_id",
        product_category_name: "product_category_name",
        product_no: "product_no",
        name: "name",
        item_detail: "item_detail",
        brand_name: "brand_name",
        variant_name: "variant_name",
        tech_spec_name: "tech_spec_name",
        default_remind_interval_day: "default_remind_interval_day",
        campaign_code: "campaign_code"
      )
    end
end
