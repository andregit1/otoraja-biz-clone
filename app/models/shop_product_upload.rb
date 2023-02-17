class ShopProductUpload
  include ActiveModel::Model

  attr_accessor :file
  validate :presence?
  validate :valid_content_type?
  validate :valid_format?
  validate :check_data

  SHOP_PRODUCT_COLUMNS = %w(product_no product_class_name product_category_id product_category_name admin_product_id shop_alias_name item_detail stock_minimum sales_unit_price remind_interval_day purchase_unit_price stock in_store)

  PRODUCT_NO_LENGTH = 255
  SHOP_ALIAS_NAME_LENGTH = 255
  ITEM_DETAIL_LENGTH = 255
  
  def self.columns
    SHOP_PRODUCT_COLUMNS
  end

  def initialize(attribute = {})
    @file = attribute.fetch(:file, nil)
    @shop_id = attribute.fetch(:shop_id, nil)
    @spreadsheet = @file.blank? ? nil : open_spreadsheet(@file)
    @shop_products = []
    @shop_products_with_error = []
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

    errors.add(:file, "format is not allowed.") unless SHOP_PRODUCT_COLUMNS.to_set.subset?(@spreadsheet.first.to_set)
  end

  def check_data
    return if errors.size > 0 || @spreadsheet.nil?

    rows = parse(@spreadsheet)
  
    product_category_ids = rows.map{|h| h[:product_category_id]}.uniq
    product_categories = ProductCategory.all.select('id').where(id: product_category_ids).map{|k| k.id}.compact
    admin_product_ids = rows.map{|h| h[:admin_product_id]}.compact
    errors.add(:file, "Duplicate admin product id") if admin_product_ids.count - admin_product_ids.uniq.count > 0
    admin_products = AdminProduct.all.select('id').where(id: admin_product_ids.uniq).map{|k| k.id}.compact
    registered_in_shop_admin_products = ShopProduct.all.select('admin_product_id').where(shop_id: @shop_id).map{|k| k.admin_product_id}.compact

    rows.each_with_index do |row, index|
      line = index + 2
      row[:line] = line
      row[:error]= []

      Rails.logger.debug("line=#{line} : #{row.inspect}")
      # in_store
      if row[:in_store].blank?
        row[:error] << valid_required('in_store', row[:in_store])
      else
        row[:error] << valid_is_boolean('in_store', row[:in_store])
      end
      
      # product_no
      unless row[:product_no].blank?
        row[:error] << valid_length('product_no', row[:product_no], PRODUCT_NO_LENGTH)
      end
      
      # product_category_id
      row[:error] << if row[:product_category_id].blank?
        "product_category_id is required."
      else
        "#{row[:product_category_id]} is an unregistered category." unless product_categories.include?(row[:product_category_id].to_i)
      end

      # admin_product_id
      unless row[:admin_product_id].blank?
        row[:error] <<  unless admin_products.include?(row[:admin_product_id].to_i)
          "Line #{line}: #{row[:admin_product_id]} is an unregistered admin product."
        else
          "#{row[:admin_product_id]} is admin product registered in shop." if registered_in_shop_admin_products.include?(row[:admin_product_id].to_i)
        end
      end

      # shop_alias_name
      row[:error] << if row[:shop_alias_name].blank?
        "Shop_alias_name is required."
      else
        valid_length('shop_alias_name', row[:shop_alias_name], SHOP_ALIAS_NAME_LENGTH)
      end

      row[:error] << "#{row[:shop_alias_name]} only alpha numeric is allowed." unless  ShopProduct::ALLOWED_REGEX =~ row[:shop_alias_name]

      # item_detail
      row[:error] << valid_length('item_detail', row[:item_detail].to_s, ITEM_DETAIL_LENGTH) if row[:item_detail].present?

      # stock_minimum
      row[:error] << valid_is_number('stock_minimum', row[:stock_minimum]) if row[:stock_minimum].present?

      # sales_unit_price
      row[:error] << valid_is_number('sales_unit_price', row[:sales_unit_price]) if row[:sales_unit_price].present?

      # remind_interval_day​
      row[:error] << valid_is_number('remind_interval_day​', row[:remind_interval_day​]) if row[:remind_interval_day​].present?

      # purchase_unit_price
      row[:error] << valid_is_number('purchase_unit_price', row[:purchase_unit_price]) if row[:purchase_unit_price].present?

      # stock
      row[:error] << valid_is_number('stock', row[:stock]) if row[:stock].present?

      
      row[:stock] = 0 if row[:purchase_unit_price].present? && row[:stock].blank?
      
      related_checks = []
      related_checks << row[:stock_minimum]
      related_checks << row[:stock]
      check_array = related_checks.reject(&:blank?)
      
      row[:error] << "stock_minimum and stock must be entered together." if 0 < check_array.count && check_array.count < related_checks.count

      row[:error] = row[:error].compact.join(", ")
  
      row.delete(:error) if row[:error].blank?

      @shop_products_with_error << row && next if row.key? :error
   
      @shop_products << row
    end
  end

  def get_shop_products
    @shop_products
  end

  def get_shop_products_with_error
    @shop_products_with_error
  end

  def get_shop_id
    @shop_id
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
        product_no: "product_no",
        product_class_name: "product_class_name",
        product_category_id: "product_category_id",
        product_category_name: "product_category_name",
        admin_product_id: "admin_product_id",
        shop_alias_name: "shop_alias_name",
        item_detail: "item_detail",
        stock_minimum: "stock_minimum",
        sales_unit_price: "sales_unit_price",
        remind_interval_day: "remind_interval_day",
        stock: "stock",
        purchase_unit_price: "purchase_unit_price",
        in_store: "in_store",
      )
    end

    def valid_length(label, value, len)
      "#{label} is larger than #{len} Bytes." if value.length > len
    end
    
    def valid_required(label, value)
      "#{label} is required." if value.blank?
    end

    def valid_is_number(label, value)
      "#{label} is not a number." unless value.is_a? Integer
    end

    def valid_is_boolean(label, value)
      "#{label} is not a boolean(0 or 1)." unless boolean?(value)
    end

    def boolean?(str)
      nil != (['0', '1'].include?(str))
    end
end

