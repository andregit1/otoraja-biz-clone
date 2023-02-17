class ShopProduct < ApplicationRecord
  include ShopProductSearchable
  include Rails.application.routes.url_helpers
  include Discard::Model

  PRODUCT_LIST_LIMIT = 10
  ALLOWED_REGEX = /^[a-zA-Z0-9!#$%&()*+,.:;=?\s\[\]^_{}<>\-\/~`'"]+$/

  belongs_to :shop
  belongs_to :product_category
  belongs_to :admin_product, optional: true
  belongs_to :maintenance_log_detail, optional: true
  belongs_to :maintenance_log_detail_related_product, optional: true
  has_one :stock
  has_many :stock_histories
  has_many :stock_controls
  has_many :purchase_histories
  has_many :packaging_product_relations_packaging, class_name: 'PackagingProductRelation', foreign_key: 'packaging_product_id', dependent: :destroy
  has_many :packaging_product_relations_inclusion, class_name: 'PackagingProductRelation', foreign_key: 'inclusion_product_id', dependent: :destroy
  has_many :packaging_products, class_name: 'ShopProduct', foreign_key: 'inclusion_product_id', through: :packaging_product_relations_inclusion
  has_many :inclusion_products, class_name: 'ShopProduct', foreign_key: 'packaging_product_id', through: :packaging_product_relations_packaging
  has_many :maintenance_log_details
  has_many :shop_invoices, through: :stock_controls

  accepts_nested_attributes_for :packaging_product_relations_packaging, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :stock, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :stock_controls, reject_if: :all_blank, allow_destroy: true

  delegate :product_no, to: :admin_product, prefix: true, allow_nil: true
  delegate :name, to: :admin_product, prefix: true, allow_nil: true
  delegate :quantity, to: :stock, prefix: true, allow_nil: true

  validate :valid_string_format?

  scope :own_shop, ->(shop_ids) {
    where(shop_id: shop_ids)
  }

  scope :enable_stock_control, ->(){
    eager_load(:stock,:admin_product,:stock_histories).where(is_use: true, is_stock_control: true)
  }

  scope :stock_report_scope, ->(shop_id, start_date, end_date, q) {
    find_by_sql("
      SELECT sp.*, ap.name ap_name, pc.name pc_name, ANY_VALUE(s.quantity) last_stock,
      SUM(CASE 
              WHEN sc1.reason = 1 AND sc1.difference IS NOT NULL
              OR sc1.reason = 4
              THEN sc1.difference
              WHEN  sc1.reason = 1 AND sc1.difference IS NULL
      	      THEN sc1.quantity
              END) AS stock_in,
      SUM(CASE 
              WHEN sc1.reason = 2
              OR sc1.reason = 3
              THEN sc1.difference
              END) AS stock_out
      FROM shop_products sp
      LEFT JOIN stocks s ON s.shop_product_id = sp.id
      LEFT JOIN stock_controls sc1 ON sc1.shop_product_id = sp.id 
                    AND sc1.stock_at_close IS NOT NULL 
                    AND sc1.date BETWEEN '#{start_date}' AND '#{end_date}'
      LEFT JOIN admin_products ap ON ap.id = sp.admin_product_id 
      LEFT JOIN product_categories pc ON pc.id = sp.product_category_id
      WHERE sp.shop_id = #{shop_id} AND sp.is_stock_control = TRUE AND sp.shop_alias_name LIKE '%#{q}%'
      GROUP BY sp.id
      ORDER BY sp.id DESC
      ")
  }

  # enum sort: {Terbaru: 0, Terlama: 1, "A-Z" => 2,Iya:3,Tidak:4}
  enum sort: [:latest, :oldest, :alphabet, :back_alphabet, :stock_high, :stock_low, :price_high, :price_low, :stock_ratio_high, :stock_ratio_low]
  enum use: [:yes, :no]

  # Set field default discard
  self.discard_column = :deleted_at
 
  def valid_string_format?
    errors.add(:shop_alias_name, "format is not allowed.") unless ALLOWED_REGEX=~ shop_alias_name
  end

  def product_name
    sprintf('%s %s',self.shop_alias_name,self.item_detail)
  end

  def is_shortage
    unless self.stock_quantity.nil? || self.stock_minimum.nil?
      self.stock_quantity < self.stock_minimum
    else
      false
    end
  end

  def has_inclusion_product?
    inclusion_products.count > 0
  end

  def category_shop_alias_name
    "#{self.product_category.name}:#{self.shop_alias_name}"
  end

  def display_product_no
    admin_product_no = admin_product&.product_no
    if admin_product_no.present?
      admin_product_no
    else
      product_no
    end
  end

  def return_stock(item_quantity)
    if self.is_stock_control?
      stock = self.stock
      stock.return_stock(item_quantity) unless stock.nil?
    end
  end

  def sale_stock(item_quantity)
    if self.is_stock_control?
      stock = self.stock
      stock.sale_stock(item_quantity) unless stock.nil?
    end
  end

  def format_name
    limit = 30
    name = self.shop_alias_name
    name.length >= limit ? name.truncate(limit)+ '... : ' : name + ': '
  end

  def last_average_price
    StockControl.where(shop_product_id: self).where.not("average_price IS NULL").last&.average_price
  end

  class << self
    include Rails.application.routes.url_helpers
    def get_products(shop_ids)
      ShopProduct.own_shop(shop_ids).eager_load({:product_category => :product_class},:stock).order('product_categories.name ASC','shop_products.shop_alias_name ASC')
    end

    def get_products_by_category(shop_ids)
      products = ShopProduct.own_shop(shop_ids).eager_load({:product_category => :product_class})
      items = Hash.new { |h,k| h[k] = {} }
      products.each do |p|
        product_class = p.product_category.product_class.name
        product_category = p.product_category.name
        if items[product_class.to_sym][product_category.to_sym].nil?
          items[product_class.to_sym][product_category.to_sym] = []
        end
        items[product_class.to_sym][product_category.to_sym].push(p)
      end
      items
    end

    def sort_condition
      {
        latest: 'updated_at desc',
        oldest: 'updated_at asc',
        alphabet: 'shop_alias_name asc, item_detail asc',
        back_alphabet: 'shop_alias_name desc, item_detail desc',
        stock_high: 'quantity desc',
        stock_low: 'quantity asc',
        price_high: 'sales_unit_price desc',
        price_low: 'sales_unit_price asc',
        stock_ratio_high: 'stock_ratio desc',
        stock_ratio_low: 'stock_ratio asc', 
      }
    end

    def generate_low_shop_product_url
      host = ENV['DOMAIN_NAME'] || 'localhost:3000'

      if Rails.env.production? || Rails.env.staging?
        protocol = 'https://'
      else
        protocol = 'http://'
      end  

      url = "#{protocol}#{host}#{admin_shop_products_path}?filter=#{ShopProduct.sorts.keys[5]}"
    end
  end
end
